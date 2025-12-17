# Combat Mode Specification

## Overview
Combat Mode is a multiplayer game mode for NuCatch where two players compete in real-time by solving math challenges. Players take turns answering questions based on the selected difficulty level, earning points for correct answers and losing lives for incorrect ones. The first player to run out of lives loses the game.

**Key Features:**
- **Pure P2P Connection**: Works completely offline using Nearby Connections API
- **Automatic Encryption**: Built-in security via Google Play Services
- **Separate UI Flows**: Distinct screens for host (advertiser) and guest (discoverer)
- **Real-time State Sync**: Instant feedback and notifications via Nearby payload messages
- **Simplified Architecture**: No manual GATT, service discovery, or bonding required

## Architecture

### Technology Stack
- **P2P Communication**: 
  - `nearby_connections` package (replaces `flutter_blue_plus` and `flutter_ble_peripheral`)
  - Google Play Services for connection management
  - Strategy: `P2P_STAR` for direct one-to-one connections
- **State Management**: BLoC pattern with `CombatBloc`, `CombatState`, and `CombatEvent`
- **Message Protocol**: JSON-based message exchange over Nearby Connections payload
- **Service Architecture**: 
  - `CombatNearbyService` - Handles advertising, discovery, connection setup, and message routing

### Security and Reliability
- **Connection**: Managed entirely by Google Play Services/Nearby Connections
- **Transport**: Automatically handles WiFi/BLE/Audio as underlying transports
- **Encryption**: Connections are automatically encrypted by the Nearby Connections API
- **Offline Capable**: Pure P2P, works completely offline

## Game Flow

### 1. Connection Phase
```
Host Device (Advertiser)                   Guest Device (Discoverer)
    |                                           |
    | Press "Create Room"                       | Press "Join Room"
    | Start Advertising (Endpoint: HostName)    | Start Discovery
    | Show: "Waiting for opponent..."           | Show: "Scanning for rooms..."
    |                                           |
    |                                           | Discover Host Endpoint
    |<----------------------------------------- | Request Connection (Endpoint ID)
    |                                           |
    | Receive Connection Request                |
    | (onConnectionInitiated)                   |
    | Show: "Opponent wants to connect!"        | Show: "Connection requested."
    | Accept Connection                         | Accept Connection
    |------------------------------------------>|
    |                                           | Connection Established
    | Connection Established                    | (onConnectionResult)
    | (onConnectionResult)                      |
    |                                           |
    |<----------------------------------------- | Send: guest_joined
    | Show: "Opponent joined!"                  |
    | Update UI: guestJoined state              | Update UI: guestJoined state
```

### 2. Ready Phase
```
Host                                      Guest
    |                                           |
    |                                           | Press "Ready" button
    |<----------------------------------------- | Send: player_ready
    | Show: "Opponent Ready!" dialog            |
    | Button changes to "Ready!"                |
    |                                           |
    | Press "Ready" button                      |
    | Send: player_ready                        |
    |------------------------------------------>| 
    |                                           | Both ready detected!
    | Both ready detected!                      |
    | Show: "Both Players Ready!" dialog        | Show: "Both Players Ready!" dialog
    | Auto-navigate to difficulty selection     | Wait for host
```

### 3. Difficulty Selection Phase
```
Host                                      Guest
    |                                           |
    | Select Difficulty Screen                  |
    | Choose: Easy/Medium/Hard/Extreme          |
    |                                           |
    | Send: difficulty_selected + game_started  |
    |------------------------------------------>|
    |                                           | Receive difficulty
    | Navigate to Combat Play                   | Navigate to Combat Play
    | Initialize game state                     | Initialize game state
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
All messages are JSON objects sent over Nearby Connections payload with automatic metadata:
- **Sender ID**: Automatically added to all messages
- **Timestamp**: Added for message ordering
- **Delivery**: Sent as UTF-8 encoded bytes via `Payload.fromBytes()`
- **Reliability**: Nearby Connections handles retry and delivery confirmation

### Delivery Mechanism
**Sending Messages**:
```dart
nearby_connections.sendPayload(
  endpointId, 
  Payload.fromBytes(utf8.encode(jsonMessage))
)
```

**Receiving Messages**:
```dart
nearby_connections.onPayloadReceived(
  (endpointId, payload) {
    final message = utf8.decode(payload.bytes);
    final json = jsonDecode(message);
    // Handle message
  }
)
```

### Room Management Messages

#### 1. guest_joined
**Sent by**: Guest (after connection established)  
**Received by**: Host  
**Purpose**: Notify host that guest successfully connected
```json
{
  "type": "guest_joined",
  "guestId": "player_1234567890_123",
  "senderId": "player_1234567890_123",
  "timestamp": 1733812345678
}
```
**Note**: Nearby Connections handles delivery reliability automatically

#### 2. player_ready
**Sent by**: Either player  
**Received by**: Opponent  
**Purpose**: Signal that player pressed the Ready button
```json
{
  "type": "player_ready",
  "senderId": "player_1234567890_123",
  "timestamp": 1733812345678
}
```
**Host Behavior**: Shows "Opponent Ready!" dialog
**Both Ready**: Triggers `RoomState.bothReady` → Auto-navigate to difficulty

#### 3. game_started
**Sent by**: Host  
**Received by**: Guest  
**Purpose**: Notify game is starting and host is selecting difficulty
```json
{
  "type": "game_started",
  "senderId": "player_1234567890_456",
  "timestamp": 1733812345678
}
```

#### 4. opponent_left
**Sent by**: Either player (on disconnect)  
**Received by**: Opponent  
**Purpose**: Clean disconnection notification
```json
{
  "type": "opponent_left",
  "senderId": "player_1234567890_123",
  "timestamp": 1733812345678
}
```

### Game Play Messages

#### 5. difficulty_selected
**Sent by**: Host  
**Received by**: Guest  
**Purpose**: Inform guest of selected difficulty
```json
{
  "type": "difficulty_selected",
  "difficulty": "Difficulty.medium",
  "senderId": "player_1234567890_456",
  "timestamp": 1733812345678
}
```

#### 6. turn_start
**Sent by**: Current active player  
**Received by**: Waiting player  
**Purpose**: Signal start of turn with challenge
```json
{
  "type": "turn_start",
  "isHostTurn": true,
  "requirement": "25 + 17",
  "expect": "42",
  "senderId": "player_1234567890_456",
  "timestamp": 1733812345678
}
```

#### 7. move_completed
**Sent by**: Player who just finished turn  
**Received by**: Opponent  
**Purpose**: Send turn results
```json
{
  "type": "move_completed",
  "input": "42",
  "correct": true,
  "score": 10,
  "lives": 3,
  "senderId": "player_1234567890_123",
  "timestamp": 1733812345678
}
```

#### 8. game_ended
**Sent by**: Player who determined game end  
**Received by**: Opponent  
**Purpose**: Signal game completion
```json
{
  "type": "game_ended",
  "isWinner": true,
  "reason": "opponent_lives_out",
  "senderId": "player_1234567890_456",
  "timestamp": 1733812345678
}
```

**Game End Reasons**:
- `opponent_lives_out`: Opponent ran out of lives
- `my_lives_out`: Current player ran out of lives
- `opponent_disconnected`: Opponent disconnected

#### 9. opponent_disconnected
**Sent by**: System (detected internally)  
**Received by**: Remaining player  
**Purpose**: Handle unexpected disconnection
```json
{
  "type": "opponent_disconnected"
}
```

## Nearby Connections Implementation

### CombatNearbyService Architecture

#### Single-Layer Service Design
**CombatNearbyService** manages the complete Nearby Connections lifecycle:
- Advertising and discovery
- Connection request handling
- Message serialization/deserialization
- Room state tracking (waiting → guestJoined → bothReady → playing → ended)
- Player ready state management
- Game lifecycle coordination

#### Core Methods

| Method | Role | Description |
|--------|------|-------------|
| `startAdvertising(hostName)` | Host | Starts advertising presence with endpoint name |
| `startDiscovery(guestName)` | Guest | Starts scanning for nearby endpoints |
| `requestConnection(endpointId)` | Guest | Sends connection request to discovered host |
| `acceptConnection(endpointId)` | Both | Accepts the connection handshake |
| `sendPayload(endpointId, message)` | Both | Sends JSON message as UTF-8 bytes payload |
| `onConnectionInitiated` | Callback | Handles incoming connection requests |
| `onConnectionResult` | Callback | Handles connection success/failure |
| `onPayloadReceived` | Callback | Handles incoming game messages |
| `disconnectFromEndpoint(endpointId)` | Both | Cleanly disconnects (sends opponent_left) |

### Host Role (HostRoomScreen)

#### Room Creation Flow
1. **Initialize Nearby Connections**
   - Check Google Play Services availability (Android)
   - Request permissions (BLUETOOTH, LOCATION, NEARBY_DEVICES)
   - Initialize Nearby Connections API
   
2. **Create Room**
   - Generate host endpoint name (e.g., "NuCatch-Host")
   - Display waiting message
   - Show notification: "🎮 Waiting for opponent..."

3. **Start Advertising**
   ```dart
   await nearbyService.startAdvertising(
     userNickname: "Player1",
     strategy: Strategy.P2P_STAR,
   );
   ```
   - Strategy: `P2P_STAR` for one-to-one connection
   - Service ID: Unique identifier for NuCatch app
   - Automatically handles underlying transport (WiFi/BLE/Audio)

#### Connection Handling
- **Connection Request**: Receive via `onConnectionInitiated` callback
- **Auto-Accept**: Automatically accept first connection request
- **Connection Result**: Confirm via `onConnectionResult` callback
- **Handshake**: Receive `guest_joined` message to confirm ready state

#### Responsibilities
- Start advertising and wait for discoverer
- Accept connection requests
- Track guest ready state
- Navigate to difficulty selection when both ready
- Start game and broadcast difficulty

### Guest Role (JoinRoomScreen)

#### Room Joining Flow
1. **Initialize Nearby Connections**
   - Same permission and API initialization as host
   
2. **Start Discovery**
   ```dart
   await nearbyService.startDiscovery(
     userNickname: "Player2",
     strategy: Strategy.P2P_STAR,
   );
   ```
   - Scan for nearby endpoints with matching Service ID
   - Display discovered endpoints in UI
   
3. **Request Connection**
   ```dart
   await nearbyService.requestConnection(
     userNickname: "Player2",
     endpointId: discoveredEndpointId,
   );
   ```
   - Select host from discovered endpoints
   - Send connection request
   - Wait for host acceptance

#### Post-Connection
- **Connection Established**: Confirmed via `onConnectionResult`
- **Send guest_joined message**: Notify host of successful connection
- **Wait for host to press Ready**
- **Press Ready when prepared**
- **Wait for host to start game**

#### Responsibilities
- Discover nearby hosts
- Request connection to selected host
- Send ready signal
- Wait for difficulty selection
- Participate in gameplay

### Connection Details

#### Security & Encryption
- **Automatic Encryption**: All connections encrypted by Nearby Connections API
- **Token-based Auth**: Connection tokens exchanged during handshake
- **Secure Channel**: Google Play Services manages secure communication
- **No Manual Bonding**: No need for device pairing

#### Message Delivery
- **Payload Type**: `Payload.fromBytes()` for JSON messages
- **Encoding**: UTF-8 string encoding
- **Max Size**: Up to 32KB per payload (well beyond our needs)
- **Reliability**: Automatic retry and delivery confirmation
- **Ordering**: Messages delivered in order sent

#### Connection Parameters
- **Strategy**: `P2P_STAR` (one-to-one)
- **Service ID**: App-specific identifier (e.g., "com.nucatch.combat")
- **Timeout**: Managed by Nearby Connections (typically 30-60s)
- **Keep-Alive**: Automatic connection monitoring
- **Reconnection**: Can be implemented at app level if needed

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

### Host Room Screen (host_room_screen.dart)
- **Header**: "Host Room" title with back button
- **Room Code Display**: Large, centered 3-digit code
- **Status Text**: Dynamic messages based on room state
  - Waiting: "Waiting for opponent to join..."
  - Guest Joined: "Opponent joined! Press Ready when both players are ready."
  - Both Ready: "✅ Both players ready! Starting game..."
- **Ready Button**: 
  - Appears when guest joins
  - Changes to green "Ready!" indicator after tap
  - Shows opponent ready notification when guest presses Ready
- **Connection Status**: Nearby Connections state indicator at bottom
- **Dialogs**:
  - "Opponent Ready!" when guest becomes ready
  - "Both Players Ready!" when both ready (auto-dismiss 2s)

### Join Room Screen (join_room_screen.dart)
- **Header**: "Join Room" title with back button
- **Endpoint List**: 
  - Displays discovered nearby endpoints
  - Shows endpoint names and connection status
  - Tap to select host
- **Connect Button**: 
  - Enabled when endpoint selected
  - Disabled after connection established
- **Status Text**: Dynamic messages based on connection state
  - Scanning: "Scanning for nearby rooms..."
  - Found: "Found X room(s). Select one to join."
  - Connecting: "Connecting to room..."
  - Connected: "Connected! Press Ready when you're prepared to play."
  - Both Ready: "✅ Both players ready! Waiting for host to start..."
  - Playing: "⏳ Waiting for host to select difficulty..."
- **Ready Button**: 
  - Appears after connection
  - Changes to green "Ready!" indicator after tap
- **Connection Status**: Nearby Connections state indicator at bottom
- **Dialogs**:
  - "Both Players Ready!" when both ready (auto-dismiss 2s)

### Combat Play Screen (Shared)
#### Header
- **My Info**: Score, Lives (left side) with difficulty icon
- **Turn Indicator**: Visual indicator of whose turn (center)
  - Green: "Your Turn"
  - Orange: "Opponent's Turn"
- **Opponent Info**: Score, Lives (right side)

#### Game Area
- **Challenge Display**: Shows `currentRequirement` (e.g., "25 + 17")
- **Answer Input**: Shows current input in styled container
  - Placeholder: "___"
  - Letter spacing for readability
- **Status Messages**: 
  - "Waiting for opponent..." when opponent is playing
  - "Opponent is playing..." when spectating

#### Controls
- **Number Keyboard**: 0-9 buttons (3×4 grid)
- **Special Buttons**:
  - Reset (disabled in combat)
  - Main Menu (with confirmation dialog)
- Only visible when `canTap` is true and it's player's turn
- Each tap appends number to input

#### Game End Screen
- **Winner Icon**: Trophy (gold) or sad face (grey)
- **Result Text**: "You Win!" or "You Lose!"
- **Reason Text**: Explanation of why game ended
- **Return Button**: Navigate back to menu

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

### Nearby Connections Errors
- **Connection timeout**: Handled automatically by Nearby Connections API
- **Disconnection during game**: Detect via `onDisconnected` callback, declare disconnected player as loser
- **Message parsing error**: Log and ignore malformed messages
- **Advertising/Discovery failure**: Retry with exponential backoff
- **Google Play Services unavailable**: Show error message and graceful degradation

### Game Logic Errors
- **Invalid input**: Ignore non-numeric input
- **Out-of-turn input**: Ignore taps when not player's turn
- **Missing challenge**: Don't allow input until challenge generated

## Performance Considerations

### Nearby Connections Optimization
- Strategy `P2P_STAR` optimized for one-to-one connections
- Automatic transport selection (WiFi Direct > BLE > Audio)
- Efficient JSON message format (keep payloads small)
- Connection keep-alive handled automatically

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
- `nearby_connections: [latest]` - Nearby Connections API (replaces flutter_blue_plus and flutter_ble_peripheral)
- `flutter_bloc` - State management
- `permission_handler` - Location and Nearby Devices permissions

### Platform Requirements
- **Android**: 
  - API 21+ (Lollipop)
  - Google Play Services required
  - **Permissions**: 
    - Android 12+: `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH_ADVERTISE`, `ACCESS_FINE_LOCATION`, `NEARBY_WIFI_DEVICES`
    - Android <12: `BLUETOOTH`, `BLUETOOTH_ADMIN`, `ACCESS_FINE_LOCATION`, `CHANGE_WIFI_STATE`
- **iOS**: 
  - iOS 13+
  - Nearby Connections uses WiFi/BLE frameworks
  - **Permissions**: Location (When In Use), Bluetooth (auto-granted)
  - **Note**: Ensure `nearby_connections` package iOS compatibility

## Testing Scenarios

### Unit Tests
- [ ] Difficulty selection logic
- [ ] Challenge generation for all difficulty levels
- [ ] Level progression calculation
- [ ] Score and lives updates
- [ ] Win/lose condition detection
- [ ] Message serialization/deserialization

### Integration Tests
- [ ] Nearby Connections initialization
- [ ] Host advertising and guest discovery
- [ ] Connection request/accept flow
- [ ] Message exchange between endpoints
- [ ] Turn switching mechanism
- [ ] Game end scenarios
- [ ] Disconnection handling

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

## Recent Improvements (December 2025)

### Completed Enhancements
1. ✅ **Migrated to Nearby Connections API**
   - Replaced BLE stack with Google's Nearby Connections
   - Eliminated manual GATT, service discovery, and bonding
   - Simplified connection flow with advertising/discovery pattern
   - Automatic encryption and reliability

2. ✅ **Separated Host and Guest Screens**
   - Created `HostRoomScreen` for advertising
   - Created `JoinRoomScreen` for discovery
   - Clearer UX with advertiser/discoverer roles

3. ✅ **Streamlined Connection Process**
   - No room codes needed (proximity-based discovery)
   - Automatic connection handshake
   - Built-in retry and delivery confirmation
   - Simplified message sending via payloads

4. ✅ **Ready State Management**
   - Visual feedback when Ready button pressed
   - "Opponent Ready!" notification for host
   - "Both Players Ready!" dialog for both players
   - Automatic navigation to difficulty selection

5. ✅ **Improved UI Feedback**
   - Advertising/Discovery status indicators
   - Guest joined notification
   - Status messages for all connection states
   - ScrollView to prevent overflow errors

6. ✅ **Robust Message Handling**
   - JSON payload serialization/deserialization
   - Proper state transitions
   - Room state enum tracking
   - Cleanup on disconnect

## Known Issues

### Current Limitations
1. **Google Play Services Dependency**: Android requires Google Play Services
   - Impact: Won't work on devices without Play Services (e.g., some Chinese ROMs)
   - TODO: Consider fallback to pure BLE for compatibility

2. **No Reconnection Logic**: Disconnection ends game immediately
   - Impact: Temporary connection drops cause game loss
   - TODO: Add brief reconnection window (30s)

3. **Multiple Nearby Rooms**: May discover multiple hosts if many games nearby
   - Impact: Guest must select correct host from list
   - Workaround: Display endpoint names clearly in UI

4. **No Input Validation**: Assumes all keyboard input is valid
   - Impact: Potential edge cases with malformed input
   - TODO: Add input sanitization

5. **No Turn Timeout**: Players can take unlimited time
   - Impact: Game can stall if player doesn't respond
   - TODO: Add 30-60s turn timer

6. **No Anti-Cheat**: Moves not validated on both devices
   - Impact: Potential for manipulation
   - TODO: Add peer validation

### Resolved Issues (via Nearby Connections)
- ✅ BLE service discovery complexity → Eliminated by Nearby Connections
- ✅ GATT authentication errors → No longer applicable
- ✅ Manual bonding required → Automatic encryption
- ✅ Characteristic setup delays → Simplified payload API
- ✅ UI overflow errors → Fixed with SingleChildScrollView
- ✅ Ready button state feedback → Added visual state changes

## Glossary

- **Nearby Connections**: Google's API for P2P data exchange over WiFi/BLE/Audio
- **Endpoint**: A device/peer in the Nearby Connections network
- **Endpoint ID**: Unique identifier for a connected peer
- **Advertising**: Broadcasting presence for discovery (Host role)
- **Discovery**: Searching for nearby endpoints (Guest role)
- **Strategy**: Connection topology (P2P_STAR for one-to-one)
- **Payload**: Data package sent between endpoints
- **Service ID**: App-specific identifier for Nearby Connections
- **Host/Advertiser**: Player who creates the room and advertises
- **Guest/Discoverer**: Player who joins by discovering and connecting
- **Turn**: One player's opportunity to solve a challenge
- **Challenge**: Math problem presented to player
- **Requirement**: The question text (e.g., "25 + 17")
- **Target**: The correct answer (e.g., "42")
- **Lives**: Number of mistakes allowed before losing
- **Level**: Difficulty progression based on score

## File Structure

```
lib/
├── screens/
│   └── menu_screens/
│       └── player/
│           ├── host_room_screen.dart      # Host advertising UI
│           ├── join_room_screen.dart      # Guest discovery UI
│           └── pairing_room_screen.dart   # Legacy BLE screen (deprecated)
├── services/
│   ├── combat_nearby_service.dart        # Nearby Connections management
│   ├── combat_ble_service.dart           # Legacy BLE service (deprecated)
│   └── enhanced_bluetooth_service.dart   # Legacy BLE service (deprecated)
├── blocs/
│   └── objects/
│       └── combat/
│           ├── combat_bloc.dart          # Combat game state management
│           ├── combat_event.dart         # Combat events
│           └── combat_state.dart         # Combat state
└── models/
    └── difficulty_model.dart             # Difficulty configurations
```

---

**Version**: 3.0  
**Last Updated**: December 11, 2025  
**Status**: Architecture Migration to Nearby Connections

## Changelog

### Version 3.0 (December 11, 2025)
- **MAJOR**: Migrated from BLE to Google Nearby Connections API
- Removed manual GATT, service discovery, and bonding complexity
- Simplified connection flow with advertising/discovery pattern
- Automatic encryption and message delivery reliability
- Updated architecture to use `CombatNearbyService`
- Removed room codes (proximity-based discovery)
- Updated dependencies and permissions

### Version 2.0 (December 10, 2025)
- Separated host and guest into dedicated screens
- Added automatic BLE device bonding
- Implemented delayed guest join message with retry
- Added ready state notifications and dialogs
- Fixed UI overflow issues
- Enhanced error handling and logging

### Version 1.0 (December 2, 2025)
- Initial combat mode implementation
- Basic BLE connection
- Turn-based gameplay
- Difficulty selection
- Score and lives tracking
