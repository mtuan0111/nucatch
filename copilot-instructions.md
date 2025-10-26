# NuCatch Flutter App - Copilot Instructions

## Project Overview
**NuCatch** is a Flutter-based number recognition game that uses the **BLoC (Business Logic Component) pattern** for state management. The game challenges players to match target numbers/calculations with different difficulty levels, featuring audio/vibration feedback, leaderboards, and Firebase integration.

### Key Technologies
- **Flutter SDK**: ^3.2.5
- **State Management**: flutter_bloc ^8.1.4 (BLoC pattern)
- **Backend**: Firebase (Firestore, Authentication)
- **Localization**: flutter_localizations (English/Vietnamese)
- **Audio/Vibration**: audioplayers ^5.2.1, vibration ^3.1.3
- **UI**: Material Design with custom gradient themes

---

## 🏗️ Architecture Patterns

### 1. **BLoC Architecture** 
The app follows strict BLoC patterns with proper separation of concerns:

```
📁 lib/blocs/
├── 📁 objects/        # Business Logic BLoCs
│   ├── 📁 audio/      # Audio management
│   ├── 📁 turn/       # Core game logic
│   ├── 📁 vibration/  # Haptic feedback
│   ├── 📁 setting/    # App settings
│   └── 📁 user/       # User management
└── 📁 navs/           # Navigation BLoCs
    ├── 📁 menu/       # Main menu navigation
    ├── 📁 player/     # Game screen navigation
    └── 📁 top_score/  # Leaderboard navigation
```

**CRITICAL RULES:**
- ❌ **NO UI logic in BLoCs** (no BuildContext, no toasts, no navigation)
- ✅ **BLoCs only emit pure state data**
- ✅ **UI layer handles all UI interactions via BlocListener/BlocBuilder**
- ✅ **Use dependency injection for BLoC-to-BLoC communication**

### 2. **Event-Driven Communication**
BLoCs communicate through events, not direct method calls:

```dart
// ✅ CORRECT: Event-driven
_audioBloc.add(PlayTapAudio());
_vibrationBloc.add(VibrateShort());

// ❌ WRONG: Direct method calls
_audioService.playTap();
```

### 3. **State Pattern**
All states are immutable with `copyWith` methods:

```dart
class TurnState {
  final int level;
  final int point;
  final bool isLoading;
  
  const TurnState({
    this.level = 0,
    this.point = 0,
    this.isLoading = false,
  });
  
  TurnState copyWith({
    int? level,
    int? point,
    bool? isLoading,
  }) => TurnState(
    level: level ?? this.level,
    point: point ?? this.point,
    isLoading: isLoading ?? this.isLoading,
  );
}
```

---

## 📱 Core Game Components

### **TurnBloc** - Main Game Controller
**Purpose**: Manages core game logic, player inputs, level progression
**Key Events**: 
- `PlayerTapped` (alias: `Tap`) - Player keyboard input
- `GameStarted` (alias: `Start`) - Initialize game
- `LevelChanged` (alias: `SetLevel`) - Progress to next level
- `SaveRecorded` - Save game results

**Key State Fields**:
- `level`: Current difficulty level
- `expect`: Target string player must match
- `typing`: Player's current input
- `lifeRemaining`: Lives left
- `status`: Game phase (intro, playing, gameOver)

### **AudioBloc** - Sound Management
**Events**: `PlayTapAudio`, `PlayCorrectAudio`, `PlayWrongAudio`, `SetAudioVolume`
**Integration**: TurnBloc communicates via events only

### **VibrationBloc** - Haptic Feedback
**Events**: `VibrateShort`, `VibrateLong`, `VibrateMultiple`, `SetVibrationEnabled`
**Usage**: Different vibration patterns for game events

---

## 🌍 Localization System

### Multi-language Support
- **English** (`app_en.arb`)
- **Vietnamese** (`app_vi.arb`)

### Usage Pattern:
```dart
// ✅ CORRECT: Use lang() helper
Text(lang(context).ready)  // "Ready!!" or "Sẵn sàng!!"
Toast(lang(context).insertedSuccess)  // Localized success message

// ❌ WRONG: Hardcoded strings
Text("Ready!!")
```

### Key Localized Messages:
- `insertedSuccess` - Save success notification
- `insertedFailed` - Save failure notification  
- `ready`, `go` - Game countdown messages
- Game difficulty descriptions and titles

---

## 🎮 Game Logic Flow

### 1. **Game Initialization**
```
Start → SetDifficulty → GameStarted → SetLevel → ShowExpect → Playing
```

### 2. **Player Input Processing**
```
PlayerTapped → Correct/Wrong Check → Update Lives/Points → Level Check → Continue/GameOver
```

### 3. **Difficulty Progression**

#### **Difficulty Levels Overview**
The game has four difficulty levels with distinct characteristics:

| Difficulty | Time Limit | Characters | Points/Turn | Turns/Level |
|------------|------------|------------|-------------|-------------|
| **Easy**   | 30 seconds | 4 chars    | 1 point     | 3 turns     |
| **Medium** | 20 seconds | 6 chars    | 2 points    | 5 turns     |
| **Hard**   | 10 seconds | 8 chars    | 4 points    | 3 turns     |
| **Extreme**| 5 seconds  | 10 chars   | 8 points    | 3 turns     |

#### **Mathematical Expression Generation by Difficulty**

**Easy Difficulty:**
- **Random Numbers**: `Helper().generateRandomNumber(level + 2)` - generates numbers with (level + 2) digits
- **Plus/Minus**: `Helper().randomCalculatorWithPlusMinus(level)` - creates addition/subtraction with result having `level` digits
- **Multiplication/Division**: Not used in Easy mode

**Medium Difficulty:**
- **Random Numbers**: `Helper().generateRandomNumber(level + 2)` - generates numbers with (level + 2) digits  
- **Plus/Minus**: `Helper().randomCalculatorWithPlusMinus(level)` - creates expressions with result having `level` digits
- **Multiplication/Division**: `Helper().randomCalculatorWithMulDiv(level)` - creates mult/div with result having `level` digits

**Hard Difficulty:**
- **Random Numbers**: `Helper().generateRandomNumber(level + 2)` - generates numbers with (level + 2) digits
- **Plus/Minus**: `Helper().randomCalculatorWithPlusMinus(level)` - creates expressions with result having `level` digits
- **Multiplication/Division**: `Helper().randomCalculatorWithMulDiv(level)` - creates mult/div with result having `level` digits

**Extreme Difficulty (Randomized):**
- **Complex Plus/Minus**: `Helper().randomCalculatorWithPlusMinus(level + 2)` - enhanced complexity with (level + 2) digit results
- **Extended Random Numbers**: `Helper().generateRandomNumber(level + 5)` - generates much longer numbers with (level + 5) digits
- **Complex Multiplication/Division**: `Helper().randomCalculatorWithMulDiv(level + 2)` - enhanced mult/div with (level + 2) digit results

#### **Level Progression Mechanics**

**Level Advancement:**
- Players advance to the next level when `isAbleToLevelUp` returns true
- Level progression affects expression complexity: higher levels = longer numbers/results
- Example progression:
  - Level 1: 3-digit results (level + 2 = 3)
  - Level 5: 7-digit results (level + 2 = 7)  
  - Level 10: 12-digit results (level + 2 = 12)

**Expression Length Calculations:**
- **Addition/Subtraction**: Result length = `lengthOfExpected` parameter
  - Easy/Medium/Hard: `level` digits
  - Extreme: `level + 2` digits
- **Random Numbers**: Length = `minLengthOfNumber` parameter
  - Easy/Medium/Hard: `level + 2` digits
  - Extreme: `level + 5` digits
- **Multiplication/Division**: Complex factor-based validation ensures non-trivial calculations

#### **Complexity Examples by Level**

**Level 1:**
- Easy: 3-digit random numbers, 1-digit calculation results
- Medium: 3-digit random numbers, 1-digit calculation results
- Extreme: 6-digit random numbers, 3-digit calculation results

**Level 5:**
- Easy: 7-digit random numbers, 5-digit calculation results
- Medium: 7-digit random numbers, 5-digit calculation results  
- Extreme: 10-digit random numbers, 7-digit calculation results

**Level 10:**
- Easy: 12-digit random numbers, 10-digit calculation results
- Medium: 12-digit random numbers, 10-digit calculation results
- Extreme: 15-digit random numbers, 12-digit calculation results

### 4. **End Game Flow**
```
GameEnded → Create TurnRecordedModel → SaveRecorded → Toast Notification
```

---

## 🔧 Services Layer

### **TurnRecordedServices**
- Firebase Firestore integration
- Local SQLite backup
- Leaderboard management

### **AudioServices** 
- Background audio management
- Volume control
- Multiple sound effects

### **VibrationServices**
- Haptic feedback patterns
- Platform-specific vibration

---

## 🎨 UI Guidelines

### **Theme System**
- **Primary**: Gradient backgrounds with `LayoutConfig`
- **Typography**: Custom font scaling with `titleSectionStyle`
- **Colors**: Material Design with scaffold background overlays

### **Component Patterns**
```dart
// ✅ CORRECT: BlocListener for side effects
BlocListener<TurnBloc, TurnState>(
  listenWhen: (prev, curr) => prev.saveSuccess != curr.saveSuccess,
  listener: (context, state) {
    if (state.saveSuccess) {
      Fluttertoast.showToast(msg: lang(context).insertedSuccess);
    }
  },
  child: BlocBuilder<TurnBloc, TurnState>(...),
)

// ❌ WRONG: UI logic in BLoC
// Never put toast/dialog/navigation in BLoC
```

### **Screen Organization**
```
📁 lib/screens/
├── 📄 menu_screen.dart       # Main menu hub
├── 📁 menu_screens/
│   ├── 📄 setting_screen.dart     # Game settings
│   ├── 📄 top_score_screen.dart   # Leaderboard list  
│   └── 📁 player/
│       └── 📄 play_screen.dart     # Main game interface
```

---

## 🚫 Common Anti-Patterns to Avoid

### ❌ **BuildContext in BLoCs**
```dart
// WRONG - BLoCs should never use BuildContext
class TurnBloc {
  void showToast(BuildContext context) { ... } // ❌ NO!
}
```

### ❌ **Direct Service Calls from BLoCs**
```dart
// WRONG - Use events instead
_audioService.playSound(); // ❌ NO!

// CORRECT
_audioBloc.add(PlayTapAudio()); // ✅ YES!
```

### ❌ **Mutable State**
```dart
// WRONG - State must be immutable
state.level++; // ❌ NO!

// CORRECT - Use copyWith
emit(state.copyWith(level: state.level + 1)); // ✅ YES!
```

### ❌ **Business Logic in UI**
```dart
// WRONG - Keep logic in BLoCs
if (userInput == targetValue) {
  // Complex game logic here ❌ NO!
}

// CORRECT - Delegate to BLoC
context.read<TurnBloc>().add(PlayerTapped(keyValue: input));
```

---

## 🔄 Event Naming Conventions

### **Current Events** (Preferred)
- `PlayerTapped`, `GameStarted`, `LevelChanged`
- **Pattern**: `[Subject][Action]ed` (past tense)

### **Legacy Aliases** (Backward Compatibility)
- `Tap` → `PlayerTapped`
- `Start` → `GameStarted` 
- `SetLevel` → `LevelChanged`

**Note**: When refactoring, prefer new naming but maintain aliases for compatibility.

---

## 🧪 Testing Guidelines

### **BLoC Testing Pattern**
```dart
blocTest<TurnBloc, TurnState>(
  'should increase level when SetLevel event is added',
  build: () => TurnBloc(initialState),
  act: (bloc) => bloc.add(SetLevel(level: 2)),
  expect: () => [
    isA<TurnState>().having((s) => s.level, 'level', 2),
  ],
);
```

### **UI Testing with BLoCs**
- Mock BLoCs for widget tests
- Test BlocListener callbacks
- Verify proper event dispatching

---

## 📝 Development Workflow

### **Adding New Features**
1. **Create Events** - Define what can happen
2. **Update State** - Add necessary data fields
3. **Implement BLoC logic** - Handle events → emit states  
4. **Update UI** - Listen to state changes
5. **Add localization** - Update ARB files
6. **Test** - Unit tests for BLoCs, widget tests for UI

### **Debugging Tips**
- Use `BlocObserver` to log all BLoC events/states
- Check event handler registration in BLoC constructors
- Verify `listenWhen` conditions in BlocListeners
- Use Flutter Inspector for widget tree analysis

---

## 🔐 Firebase Integration

### **Firestore Collections**
- `turns` - Game records with user stats
- `users` - Player profiles and preferences

### **Security Rules**
- Authenticated writes only
- Public reads for leaderboards
- User-specific data isolation

---

## 📱 Platform Considerations

### **Android**
- Vibration permissions in AndroidManifest.xml
- Audio focus management
- Firebase configuration (google-services.json)

### **iOS** 
- Haptic feedback entitlements
- Audio session categories
- Firebase configuration (GoogleService-Info.plist)

---

## 🎯 Performance Guidelines

### **BLoC Performance**
- Use `Equatable` for states (prevent unnecessary rebuilds)
- Implement `listenWhen`/`buildWhen` conditions
- Avoid heavy computations in event handlers

### **UI Performance**
- Use `const` constructors where possible
- Implement proper `RepaintBoundary` usage
- Optimize list rendering with builders

---

This documentation should guide all development work on the NuCatch Flutter app. Always follow BLoC patterns, maintain proper separation of concerns, and prioritize code maintainability and testability.