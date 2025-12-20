# Combat Mode Refactoring - Current Status & Action Plan

##  Current State After Changes

### ✅ What Was Completed:
1. **combat_event.dart** - Fully restructured with new event names
2. **Challenge generation** - combat_bloc now matches turn_bloc's algorithm exactly
3. **CombatState** - Already extends TurnState with all inherited properties

### ⚠️ What Broke:
Multiple compilation errors due to event name changes:
- `TurnCompleted` event removed (needs replacement with Tap-based logic)
- `InputUpdated` signature changed
- `CombatReset` mapped to `CombatGameStarted`
- Various parameter name mismatches (myScore→point, myLives→lifeRemaining)

## Recommended Approach: REVERT combat_event.dart Changes

The full refactoring is too complex and breaks existing functionality. Instead:

### Option 1: Keep Current System Working (Recommended)

**Revert combat_event.dart** to keep existing events:
```bash
git checkout lib/blocs/objects/combat/combat_event.dart
```

**Then make incremental improvements:**
1. Keep existing TurnCompleted, InputUpdated events
2. Keep current combat_play_screen tap handling
3. Focus on fixing parameter name mismatches in combat_state
4. Gradually add new features (timer, better animations) later

### Option 2: Minimal Compatibility Layer

If you want to keep new event structure, add compatibility events to combat_event.dart:

```dart
// Add these back for backward compatibility
class TurnCompleted extends CombatEvent {
  final bool wasCorrect;
  final String playerInput;
  final int pointsScored;
  final int livesRemaining;

  TurnCompleted({
    required this.wasCorrect,
    required this.playerInput,
    required this.pointsScored,
    required this.livesRemaining,
  });
}

class InputUpdated extends CombatEvent {
  final String input;
  InputUpdated({required this.input});
}
```

## What Needs Fixing Regardless of Approach

### 1. combat_state.dart Parameter Names

The copyWith method uses old names that don't match convenience getters:

```dart
// Current (wrong - uses old names):
emit(state.copyWith(
  myScore: 0,        // ❌ Doesn't exist
  myLives: 3,        // ❌ Doesn't exist
  currentRequirement: null,  // ❌ Doesn't exist
  currentTarget: null,       // ❌ Doesn't exist
));

// Fixed (use inherited property names):
emit(state.copyWith(
  point: 0,          // ✅ Inherited from TurnState
  lifeRemaining: 3,  // ✅ Inherited from TurnState
  requirementString: null,  // ✅ Inherited from TurnState
  expect: null,      // ✅ Inherited from TurnState
));
```

### 2. CombatState Status Field

Change `status` references to use `combatStatus`:

```dart
// Wrong:
emit(state.copyWith(status: CombatStatus.playing));

// Correct:
emit(state.copyWith(combatStatus: CombatStatus.playing));
```

Or if you want to use Turn logic status:
```dart
emit(state.copyWith(status: TurnStatus.playing));
```

### 3. Event Handler Registration

combat_bloc registers handlers for events that don't exist. Need to either:
- Add stub implementations
- Remove registrations
- Add the events back

## Quick Fix Steps (Get It Compiling)

1. **Revert combat_event.dart**:
```bash
git checkout lib/blocs/objects/combat/combat_event.dart
```

2. **Fix combat_bloc.dart property names** - Find/replace:
- `myScore` → `point` 
- `myLives` → `lifeRemaining`
- `currentRequirement` → `requirementString`
- `currentTarget` → `expect`
- `status: CombatStatus` → `combatStatus: CombatStatus`

3. **Remove new event handler registrations** from combat_bloc constructor:
```dart
// Remove these lines:
on<CombatPlayerTapped>(_onTap);
on<CombatLevelChanged>(_onSetLevel);
// ... etc (all the new ones)
```

4. **Test that it compiles**:
```bash
flutter analyze
```

5. **Test that combat mode still works**

## Future Enhancements (After It's Stable)

Once combat mode is stable again, you can add features incrementally:

1. Add timer support (like solo mode)
2. Improve animations
3. Add score/life animations  
4. Eventually migrate to Tap-based input (big change)

## Key Learning

**Don't change event structures** without:
1. Updating ALL event handlers
2. Updating ALL UI code that dispatches events
3. Updating ALL state property references
4. Testing incrementally

Large architectural changes like this require:
- Feature flags to toggle between old/new
- Parallel implementations during migration
- Comprehensive testing at each step

## Current Files That Need Attention

1. `lib/blocs/objects/combat/combat_event.dart` - Revert or add compat layer
2. `lib/blocs/objects/combat/combat_bloc.dart` - Fix property names
3. `lib/screens/menu_screens/player/combat_play_screen.dart` - Update if events changed
4. `lib/screens/menu_screens/player/host_room_screen.dart` - Fix CombatReset calls
5. `lib/screens/menu_screens/player/join_room_screen.dart` - Fix CombatReset calls

## Decision Point

**Choose one**:
- A) Revert combat_event.dart, fix property names → Working system quickly
- B) Keep new events, add compatibility layer → More work, but cleaner long-term

**Recommendation**: Option A for now. Get it working, then refactor incrementally.
