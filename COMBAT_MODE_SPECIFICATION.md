# Combat Mode Specification

## Overview
Combat Mode is a multiplayer game mode for NuCatch where two players compete in real-time by solving math challenges. Players take turns answering questions based on the selected difficulty level, earning points for correct answers and losing lives for incorrect ones. The first player to run out of lives loses the game.

## Architecture

### Technology Stack
- **Bluetooth Communication**: Uses `flutter_blue_plus` for BLE scanning/connection and `flutter_ble_peripheral` for advertising
- **State Management**: BLoC pattern with `CombatBloc`, `CombatState`, and `CombatEvent`
- **Message Protocol**: JSON-based message exchange over Bluetooth GATT characteristics

## Game Flow

### 1. Connection Phase
```
Host Device                          Guest Device
    |                                     |
    | Start Advertising (Room Code)      |
    |------------------------------------>|
    |                                     | Start Scanning
    |                                     |---> Discover Host
    |                                     |
    |<----------------------------------- | Connect Request
    | Accept Connection                   |
    |------------------------------------>|
    |         Connected (BLE GATT)        |
```

### 2. Setup Phase
```
Host                                 Guest
    |                                     |
    | Select Difficulty                   | 
    | (Easy/Medium/Hard/Extreme)          |
    |                                     |
    | Send: difficulty_selected           |
    |------------------------------------>|
    |                                     | Initialize Game
    | Initialize Game                     |
```

### 3. Game Loop
```
Current Player                       Opponent
    |                                     |
    | Generate Challenge                  |
    | Send: turn_start                    |
    |------------------------------------>|
    |                                     | Display Challenge
    | Display Challenge                   |
    |                                     |
    | Player solves challenge             | Wait & Observe
    |                                     |
    | Send: move_completed                |
    |------------------------------------>|
    |                                     | Update Opponent State
    | Update My State                     |
    |                                     |
    |<----------------------------------- | Switch Turns
    | Wait & Observe                      | Player solves challenge
    |                                     |
    (Repeat until game ends)
```

## Game States

### CombatStatus Enum
- **`waiting`**: Initial state, waiting for game to start
- **`hostSelecting`**: Host is selecting difficulty level
- **`starting`**: Game is starting (could include countdown)
- **`playing`**: Active gameplay
- **`ended`**: Game has finished

### CombatState Properties

#### Player Information
- `isHost: bool` - Whether this player is the host
- `isMyTurn: bool` - Whether it's currently this player's turn
- `isGameActive: bool` - Whether the game is currently active

#### Scores & Lives
- `myScore: int` - Current player's score (starts at 0)
- `myLives: int` - Current player's remaining lives (starts at 3)
- `opponentScore: int` - Opponent's score (starts at 0)
- `opponentLives: int` - Opponent's remaining lives (starts at 3)

#### Turn Information
- `currentRequirement: String?` - The challenge text displayed to both players (e.g., "25 + 17")
- `currentTarget: String?` - The correct answer both players must type (e.g., "42")
- `myInput: String` - Current player's typed input
- `opponentInput: String?` - Opponent's last input (for display)
- `isWaitingForOpponent: bool` - Whether waiting for opponent to finish their turn

#### Game Status
- `difficultyModel: DifficultyModel?` - Selected difficulty configuration
- `status: CombatStatus` - Current game status
- `isWinner: bool?` - Game result (null = ongoing, true = won, false = lost)
- `gameEndReason: String?` - Reason why the game ended

#### Computed Properties
- `canTap: bool` - Whether player can input (isMyTurn && isGameActive && currentTarget != null)
- `isComplete: bool` - Whether current input matches target
- `hasGameEnded: bool` - Whether game has ended (isWinner != null)
- `isOpponentActive: bool` - Whether opponent is currently playing

## Difficulty Levels

### Easy
- **Challenge Type**: Number memorization
- **Example**: Display "123", player types "123"
- **Points per Turn**: Defined in DifficultyModel
- **Level Scaling**: Increases number length

### Medium
- **Challenge Type**: Addition and subtraction
- **Example**: "25 + 17" → Answer: "42"
- **Points per Turn**: Defined in DifficultyModel
- **Level Scaling**: Larger numbers, more operations

### Hard
- **Challenge Type**: Multiplication and division
- **Example**: "8 × 7" → Answer: "56"
- **Points per Turn**: Defined in DifficultyModel
- **Level Scaling**: More complex calculations

### Extreme
- **Challenge Type**: Advanced multiplication and division
- **Example**: "144 ÷ 12" → Answer: "12"
- **Points per Turn**: Defined in DifficultyModel
- **Level Scaling**: More digits, harder operations

## Message Protocol

### Message Format
All messages are JSON objects sent over BLE GATT characteristic with UUID: `0000ffe1-0000-1000-8000-00805f9b34fb`

### Message Types

#### 1. difficulty_selected
**Sent by**: Host  
**Received by**: Guest  
**Purpose**: Inform guest of selected difficulty
```json
{
  "type": "difficulty_selected",
  "difficulty": "Difficulty.medium"
}
```

#### 2. turn_start
**Sent by**: Current active player  
**Received by**: Waiting player  
**Purpose**: Signal start of turn with challenge
```json
{
  "type": "turn_start",
  "isHostTurn": true,
  "requirement": "25 + 17",
  "expect": "42"
}
```

#### 3. move_completed
**Sent by**: Player who just finished turn  
**Received by**: Opponent  
**Purpose**: Send turn results
```json
{
  "type": "move_completed",
  "input": "42",
  "correct": true,
  "score": 10,
  "lives": 3
}
```

#### 4. game_ended
**Sent by**: Player who determined game end  
**Received by**: Opponent  
**Purpose**: Signal game completion
```json
{
  "type": "game_ended",
  "isWinner": true,
  "reason": "opponent_lives_out"
}
```

**Game End Reasons**:
- `opponent_lives_out`: Opponent ran out of lives
- `my_lives_out`: Current player ran out of lives
- `opponent_disconnected`: Opponent disconnected

#### 5. opponent_disconnected
**Sent by**: System (detected internally)  
**Received by**: Remaining player  
**Purpose**: Handle unexpected disconnection
```json
{
  "type": "opponent_disconnected"
}
```

## Bluetooth Implementation

### Host Role

#### Advertising
- **Service UUID**: Generated from room code (e.g., room 477 → `000001dd-0000-1000-8000-00805f9b34fb`)
- **Local Name**: `NuCatch-{roomCode}` (e.g., "NuCatch-477")
- **Manufacturer Data**: Room code as UTF-8 bytes
- **Manufacturer ID**: `0x004C` (Apple compatibility)
- **TX Power**: High (maximum range)
- **Advertising Mode**: Balanced (visibility + battery)
- **Connectable**: Yes
- **Timeout**: None (indefinite)

#### Responsibilities
- Start BLE advertising with room code
- Accept incoming connections from guests
- Select and broadcast difficulty level
- Generate challenges for each turn
- Start first turn

### Guest Role

#### Scanning
- **Service Filter**: Temporarily disabled (scans all devices for debugging)
- **Timeout**: 30 seconds
- **Fine Location**: Required (Android)

#### Discovery Matching (Priority Order)
1. **Perfect Match**: Device name contains "NuCatch-{roomCode}"
2. **Good Match**: Service UUID + Manufacturer data both match
3. **Risky Match**: Service UUID only (accepted with warning)
4. **Rejected**: Manufacturer data only (too risky)

#### Responsibilities
- Scan for host advertising the room code
- Connect to host device
- Wait for difficulty selection
- Participate in turn-based gameplay

### Connection Details
- **Protocol**: BLE GATT (Generic Attribute Profile)
- **Service UUID**: Custom per room code
- **Characteristic UUID**: `0000ffe1-0000-1000-8000-00805f9b34fb`
- **Characteristic Properties**: Read, Write, Notify
- **MTU**: Default BLE MTU (typically 23-512 bytes)
- **Connection Timeout**: 2-6 seconds (with retry logic)
- **Retry Strategy**: 3 attempts with increasing timeouts (4s, 5s, 6s)

## Turn Mechanics

### Turn Sequence
1. **Turn Start**
   - Generate challenge based on difficulty and current level
   - Display challenge to both players
   - Active player can input, opponent observes

2. **Input Processing**
   - Each key press appends to `myInput`
   - Check if input matches `currentTarget`
   - If match: Award points, maintain lives
   - If wrong: No points, lose 1 life
   - Update occurs when input length equals target length

3. **Turn Completion**
   - Send results to opponent
   - Check win/lose conditions
   - Switch turns (unless game ended)

4. **Turn Switch**
   - Previous active player waits
   - Previous waiting player becomes active
   - New challenge generated

### Level Progression
- **Level Formula**: `(myScore ÷ pointsPerTurn) + 1`
- **Level Effects**: 
  - Easy: Longer numbers
  - Medium: Larger numbers in calculations
  - Hard: More complex multiplication/division
  - Extreme: Even more challenging calculations

## Win/Lose Conditions

### Losing Conditions
1. **Run out of lives** (myLives reaches 0)
   - Player who runs out loses immediately
   - Opponent wins

2. **Opponent disconnects**
   - Remaining player wins by default
   - Reason: `opponent_disconnected`

### Winning Conditions
1. **Opponent runs out of lives** (opponentLives reaches 0)
   - Current player wins

2. **Opponent disconnects**
   - Current player wins by default

## Screen Components

### Header
- **My Info**: Score, Lives (left side)
- **Turn Indicator**: Visual indicator of whose turn (center)
- **Opponent Info**: Score, Lives (right side)

### Game Area
- **Challenge Display**: Shows `currentRequirement` (e.g., "25 + 17")
- **Answer Input**: Shows current input with placeholder underscores
- **Status Messages**: 
  - "Waiting for opponent..." when opponent is playing
  - "Your turn!" when player should input
  - "Watching opponent..." when spectating

### Controls
- **Number Keyboard**: 0-9 buttons (3×4 grid)
- Only visible when `canTap` is true
- Each tap appends number to input

### Game End Screen
- **Winner Icon**: Trophy (gold) or sad face (grey)
- **Result Text**: "You Win!" or "You Lose!"
- **Reason Text**: Explanation of why game ended
- **Return Button**: Navigate back to play mode selection

## Events

### CombatEvent Types

1. **CombatGameStarted**
   - Initializes combat game with difficulty and host status
   - Sets initial scores and lives

2. **DifficultySelected**
   - Host selects difficulty level
   - Broadcasts to guest

3. **TurnStarted**
   - Begins a new turn for specified player
   - Generates new challenge

4. **InputUpdated**
   - Player types a number
   - Updates `myInput` state

5. **TurnCompleted**
   - Player finishes turn (correct or incorrect)
   - Updates scores and lives
   - Broadcasts to opponent

6. **OpponentMoveReceived**
   - Receives opponent's turn results
   - Updates opponent state
   - Triggers turn switch

7. **GameEnded**
   - Game finishes with winner determination
   - Sets final game state

8. **OpponentDisconnected**
   - Handles unexpected disconnection
   - Declares remaining player as winner

## Error Handling

### Bluetooth Errors
- **Connection timeout**: Retry 3 times with increasing timeouts
- **Disconnection during game**: Declare disconnected player as loser
- **Message parsing error**: Log and ignore malformed messages
- **Advertising failure**: Restart advertising with verification

### Game Logic Errors
- **Invalid input**: Ignore non-numeric input
- **Out-of-turn input**: Ignore taps when not player's turn
- **Missing challenge**: Don't allow input until challenge generated

## Performance Considerations

### Bluetooth Optimization
- Use balanced advertising mode (good visibility + battery)
- High TX power for maximum range
- No advertising timeout (indefinite)
- Efficient JSON message format

### State Updates
- Minimal state changes per turn
- Broadcast pattern for message streams
- Cancel subscriptions on bloc disposal

### UI Responsiveness
- Immediate input feedback
- Turn indicator updates
- Real-time score/lives display
- Status message updates

## Future Enhancements

### Potential Features
1. **Countdown Timer**: Add time pressure to each turn
2. **Power-ups**: Special abilities (skip turn, double points, restore life)
3. **Tournament Mode**: Multiple rounds with bracket system
4. **Spectator Mode**: Allow others to watch matches
5. **Replay System**: Review past games
6. **Achievements**: Unlock rewards for wins, streaks, perfect games
7. **Leaderboard**: Global/local rankings
8. **Custom Rooms**: Named rooms instead of numeric codes
9. **Chat System**: Pre-game and post-game messaging
10. **Sound Effects**: Audio feedback for actions

### Technical Improvements
1. **Reconnection Logic**: Handle temporary disconnections
2. **Save State**: Persist game state for app crashes
3. **Network Fallback**: Use WiFi Direct if BLE fails
4. **Anti-cheat**: Validate moves on both devices
5. **Lag Compensation**: Handle delayed messages
6. **Analytics**: Track game statistics and patterns

## Dependencies

### Flutter Packages
- `flutter_blue_plus: ^1.36.8` - BLE scanning and connection
- `flutter_ble_peripheral` - BLE advertising (host mode)
- `flutter_bloc` - State management
- `permission_handler` - Bluetooth and location permissions

### Platform Requirements
- **Android**: API 21+ (Lollipop), BLE support
- **iOS**: iOS 13+, BLE support
- **Permissions**: 
  - Android 12+: BLUETOOTH_SCAN, BLUETOOTH_CONNECT, BLUETOOTH_ADVERTISE, LOCATION
  - Android <12: BLUETOOTH, LOCATION
  - iOS: Bluetooth (auto-granted)

## Testing Scenarios

### Unit Tests
- [ ] Difficulty selection logic
- [ ] Challenge generation for all difficulty levels
- [ ] Level progression calculation
- [ ] Score and lives updates
- [ ] Win/lose condition detection
- [ ] Message serialization/deserialization

### Integration Tests
- [ ] Bluetooth connection flow
- [ ] Host advertising and guest discovery
- [ ] Message exchange between devices
- [ ] Turn switching mechanism
- [ ] Game end scenarios

### Manual Testing
- [ ] Two devices connect successfully
- [ ] Difficulty selection propagates
- [ ] Turns alternate correctly
- [ ] Scores update accurately
- [ ] Lives decrease on wrong answers
- [ ] Game ends when lives reach 0
- [ ] Disconnection handling
- [ ] UI updates in real-time
- [ ] Keyboard input works correctly
- [ ] Game end screen displays correctly

## Known Issues

### Current Limitations
1. **BLE Name Override**: Android doesn't always use `localName` from advertising data
   - Workaround: Match by service UUID + manufacturer data
   - Impact: Multiple devices with same room code may cause confusion

2. **Service Filter Disabled**: Currently scanning all BLE devices
   - Reason: Debugging visibility issues
   - Impact: May discover many irrelevant devices
   - TODO: Re-enable after confirming host visibility

3. **Host Status Hardcoded**: CombatPlayScreen assumes host=true
   - TODO: Pass host status from pairing screen via navigation

4. **No Reconnection Logic**: Disconnection ends game immediately
   - TODO: Add brief reconnection window

5. **No Input Validation**: Assumes all keyboard input is valid
   - TODO: Add input sanitization

### Bug Reports
- Guest device may not see host advertising with service UUID filter enabled
- Both devices may appear as "BOM's A05s" instead of "NuCatch-{code}"
- Connection timeouts occur even when devices are nearby

## Glossary

- **BLE**: Bluetooth Low Energy
- **GATT**: Generic Attribute Profile (BLE communication protocol)
- **UUID**: Universally Unique Identifier
- **MTU**: Maximum Transmission Unit
- **TX Power**: Transmission power (signal strength)
- **Advertising**: Broadcasting BLE presence for discovery
- **Scanning**: Searching for BLE devices
- **Host**: Player who creates the room and advertises
- **Guest**: Player who joins by scanning and connecting
- **Turn**: One player's opportunity to solve a challenge
- **Challenge**: Math problem presented to player
- **Requirement**: The question text (e.g., "25 + 17")
- **Target**: The correct answer (e.g., "42")
- **Lives**: Number of mistakes allowed before losing
- **Level**: Difficulty progression based on score

---

**Version**: 1.0  
**Last Updated**: December 2, 2025  
**Status**: Implementation in Progress
