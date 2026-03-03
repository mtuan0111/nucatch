# B6-Add_pick_right_difficulty

## Summary of Changes (28 files, +450 / -483 lines)

### 1. Difficulty Re‑selection after Game Over
- Added **"Ready – Difficulty Setting"** button for host to change difficulty.
- New `wantsChangeDifficulty` flag in `CombatState`.
- New BLE flag `changeDifficulty` on `restartReady` messages.
- Updated `CombatRestartReady`, `CombatRestartReadyReceived` events and added `CombatChangeDifficultyReceived`.
- UI changes in `combat_game_end_screen.dart` and `join_room_screen.dart`.

### 2. Pick Right Turn‑Swap Gap Fix
- Skipped the `kAnimationDurationSlow` delay and the memorization `showTime` delay for Pick Right mode in both `_onCombatTurnStarted` and `_onCombatTurnReceived`.

### 3. Pick Right Options Synchronisation
- Removed `moveCompleted` BLE message on wrong tap (prevented false turn swap).
- Removed local equation regeneration on wrong tap.
- Deleted duplicate equation generation in `_onCombatLevelChanged` for Pick Right mode – now only the active player generates equations.

### 4. Simultaneous Firework Animations
- On correct Pick Right tap, trigger both button firework and life‑star firework together.

### 5. Restart State Cleanup
- `_restartGame` now clears `equations`, `correctIndex`, `selectedOption`, `pickRightJustCorrect` to avoid stale UI after a restart.

### 6. Localization – Missing Translations
- Added `pickRightTitle` and `pickRightDescription` to all eight locale ARB files (de, es, fr, hi, id, ja, th, zh).

### 7. Miscellaneous
- Countdown interval changed from 100 ms to 10 ms.
- Removed dead code from `set_difficult_screen.dart`.
- Updated `README.md` with v2.7.4 release notes.
- Minor dependency bumps in `pubspec.yaml`/`pubspec.lock`.

**Total:** 28 files changed, **+450 insertions**, **‑483 deletions**.
