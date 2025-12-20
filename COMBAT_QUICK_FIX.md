# Combat Mode - Minimal Integration Guide

## Current Status

✅ **combat_event.dart** - Updated with new structure
⚠️ **combat_bloc.dart** - Registered new event handlers but implementations missing
❌ **combat_play_screen.dart** - Still using old tap system

## Quick Fix: Keep It Working

The cleanest approach is to maintain BOTH systems temporarily:

### Option 1: Adapter Pattern (Recommended)

Keep existing combat logic working, add adapters for new events:

```dart
// In combat_bloc.dart

// NEW: Tap event maps to the string input system
Future<void> _onTap(
  CombatPlayerTapped event,
  Emitter<CombatState> emitter,
) async {
  if (!state.isAbleToTap || !state.isMyTurn) return;
  
  // Convert KeyboardOption to string
  String keyValue = keyboardArray[event.keyValue].toString();
  
  // Check for special keys
  if (event.keyValue == KeyboardOption.reset) {
    add(CombatNumberReset(duration: Duration(milliseconds: 200)));
    return;
  }
  
  if (event.keyValue == KeyboardOption.mainMenu) {
    return; // Handle menu
  }
  
  // Use existing input logic
  final newInput = state.myInput + keyValue;
  final isCorrect = newInput == state.expect;
  
  if (isCorrect) {
    // Complete turn
    await _completeTurn(true, newInput, emitter);
  } else if (newInput.length == state.expect?.length) {
    // Wrong answer
    await _completeTurn(false, newInput, emitter);
  } else {
    // Still typing
    emitter(state.copyWith(myInput: newInput));
  }
}

Future<void> _completeTurn(
  bool wasCorrect,
  String input,
  Emitter<CombatState> emitter,
) async {
  final newScore = wasCorrect
      ? state.point + (state.difficultyModel?.pointEachTurn ?? 1)
      : state.point;
  final newLives = wasCorrect ? state.lifeRemaining : state.lifeRemaining - 1;
  
  emitter(state.copyWith(
    point: newScore,
    lifeRemaining: newLives,
    myInput: '',
    isWaitingForOpponent: true,
  ));
  
  // Send to opponent
  await _sendMessage({
    'type': 'move_completed',
    'input': input,
    'correct': wasCorrect,
    'score': newScore,
    'lives': newLives,
  });
  
  // Check game end
  if (newLives <= 0) {
    add(CombatGameEnded(
      isCauseGameOver: true,
      isWinner: false,
      reason: 'my_lives_out',
    ));
    return;
  }
  
  // Start opponent turn
  add(CombatTurnStarted(isMyTurn: false));
}

// Stub implementations for missing handlers
Future<void> _onSetLevel(CombatLevelChanged event, Emitter<CombatState> emit) async {
  // TODO: Implement when needed
}

Future<void> _onAddPoint(CombatPointAdded event, Emitter<CombatState> emit) async {
  // Already handled in _completeTurn
}

Future<void> _onLostLife(CombatLifeLost event, Emitter<CombatState> emit) async {
  // Already handled in _completeTurn
}

Future<void> _onGainLife(CombatLifeGained event, Emitter<CombatState> emit) async {
  // TODO: Implement gain life on streak
}

Future<void> _onGeneratedRequiredString(
  CombatRequiredStringGenerated event,
  Emitter<CombatState> emit,
) async {
  // Use existing _generateChallenge
  final challenge = _generateChallenge();
  emit(state.copyWith(
    requirementString: challenge['expression']!,
    expect: challenge['expect']!,
  ));
}

Future<void> _onShowExpect(CombatExpectShown event, Emitter<CombatState> emit) async {
  // Generate and show, then hide after duration
  add(CombatRequiredStringGenerated());
  await Future.delayed(event.duration);
  // Continue playing
}

Future<void> _onResetNewNumber(CombatNumberReset event, Emitter<CombatState> emit) async {
  add(CombatLifeLost());
  await Future.delayed(event.duration);
  add(CombatTurnStarted(isMyTurn: true));
}

Future<void> _onSaveRecorded(CombatRecordSaved event, Emitter<CombatState> emit) async {
  // TODO: Implement save record
  event.callback?.call();
}

// Timer stubs (implement if needed)
void _onTapTimerTick(CombatTapTimerTick event, Emitter<CombatState> emit) {}
Future<void> _onTapTimerTimeout(CombatTapTimerTimeout event, Emitter<CombatState> emit) async {}
void _onTapTimerPause(CombatTapTimerPause event, Emitter<CombatState> emit) {}
void _onTapTimerResume(CombatTapTimerResume event, Emitter<CombatState> emit) {}
void _onTapTimerReset(CombatTapTimerReset event, Emitter<CombatState> emit) {}
```

### Update combat_play_screen.dart

```dart
// Replace _handleTap with KeyboardOption tap
onPressed: () {
  context.read<CombatBloc>().add(
    CombatPlayerTapped(keyValue: e.key),
  );
}

// For reset button
if (e.key == KeyboardOption.reset) {
  button = AnimatedButton(
    context,
    iconData: FontAwesomeIcons.arrowsRotate,
    isEnable: combatState.isAbleToReset && combatState.isMyTurn,
    onPressed: () {
      context.read<CombatBloc>().add(
        CombatNumberReset(duration: Duration(milliseconds: 200)),
      );
    },
  );
}
```

## Testing After Changes

1. flutter analyze (should pass)
2. Test combat mode basic gameplay
3. Test opponent communication
4. Test turn alternation

## Next Steps

Once working:
1. Add timer implementation if desired
2. Add save record functionality
3. Refine animation system
4. Match UI with solo mode
