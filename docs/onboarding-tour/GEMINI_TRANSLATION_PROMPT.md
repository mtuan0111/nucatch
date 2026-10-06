# Prompt for Gemini — translate the in-game tour lessons

Copy everything below the line into Gemini (a long-context model, e.g. Gemini 2.5 Pro). Paste its JSON answer back to Claude (or save it as `tour_translations.json`) to merge into `lib/localization/app_*.arb` and run `flutter gen-l10n`.

Generated from the code on 2026-10-06: 44 strings × 9 languages. Regenerate if lessons or English text change (see "Regenerating" at the end).

---

You are a native-quality game localizer. Translate the English UI strings below for **NuCatch**, a casual mental-math mobile game (memorize a number and type it back, pick the right answer, or race a friend in 1-v-1 Combat). The strings are the cards of the game's **hands-on onboarding tutorial**: each card sits next to a highlighted part of the real game and explains it while the player tries it.

Translate into these 9 languages: German (`de`), Spanish (`es`), French (`fr`), Hindi (`hi`), Indonesian (`id`), Japanese (`ja`), Thai (`th`), Vietnamese (`vi`), Simplified Chinese (`zh`).

## Rules

1. **Keep the markup exactly.**
   - `**text**` marks bold words. Keep the same number of `**…**` pairs, wrapping the equivalent words.
   - `\n` is a paragraph break. Keep the same number of `\n`, in the same places (one idea per paragraph).
   - Keep digits, quoted keys and equations exactly as written: `"8"`, `"2"`, `"4"`, `3`, `5 + 3`.
2. **Use the app's existing terms** from the glossary below, verbatim, whenever the text names a mode, screen, badge or button (e.g. the Game Over screen, the Combat mode, the Your Turn badge). Do not invent new names for them.
3. **Tone:** short, warm, encouraging, spoken directly to the player. Use the form of address listed per language. No exclamation marks unless the English has one.
4. **Length:** the card is about 340 pt wide on a phone.
   - **Titles:** at most ~22 characters (Latin scripts) or ~10 characters (CJK/Thai). 2–4 words, no final period.
   - **Descriptions and results:** at most 130% of the English length. Simple words; no idioms that don't translate.
5. **Meaning over words:**
   - "lives" are the 3 stars the player can lose.
   - "Reset" is a keypad key with a circular-arrows icon (no text label). Translate it as the action "reset / new challenge", consistently.
   - "host" is the player who created the Combat room.
6. Brand names stay as they are: **NuCatch**, **Bluetooth**.
7. **Output:**
   - Only one JSON object, no comments or explanations.
   - Top-level keys are the language codes; each maps every string key below to its translation.
   - All keys must be present for every language.
   - Use valid JSON escaping (`\n` stays the two characters backslash-n, quotes as `\"`).

```json
{
  "de": { "tourRuleRegularWelcomeTitle": "…", "…": "…" },
  "es": { … },
  …
}
```

## Tone per language

- **German (`de`)**: informal "du" (existing UI: "Tippe auf …")
- **Spanish (`es`)**: informal "tú" (existing UI: "Toca …")
- **French (`fr`)**: formal "vous" (existing UI: "Appuyez sur …")
- **Hindi (`hi`)**: polite "आप"
- **Indonesian (`id`)**: friendly "kamu" (existing tour text; other UI uses "Anda")
- **Japanese (`ja`)**: polite です/ます
- **Thai (`th`)**: neutral, "คุณ"
- **Vietnamese (`vi`)**: friendly "bạn"
- **Simplified Chinese (`zh`)**: friendly "你"

## Glossary — existing in-app terms (use verbatim)

| Term | `de` | `es` | `fr` | `hi` | `id` | `ja` | `th` | `vi` | `zh` |
|---|---|---|---|---|---|---|---|---|---|
| Regular (mode) | Klassisch | Clásico | Classique | क्लासिक | Klasik | クラシック | แบบคลาสสิก | Cổ điển | 经典 |
| Pick Right (mode) | Richtig Wählen | Pick Right | Choisissez Bien | सही चुनें | Pilih Benar | 正しい方を選べ | เลือกคำตอบที่ถูก | Chọn Đúng | 选出正确答案 |
| Combat Mode | Kampf-Modus | Modo Combate | Mode Combat | कॉम्बैट मोड | Mode Pertarungan | 対戦モード | โหมดต่อสู้ | Chế độ đối kháng | 对战模式 |
| Solo Mode | Solo-Modus | Modo Solo | Mode Solo | सोलो मोड | Mode Solo | ソロモード | โหมดเล่นคนเดียว | Chơi đơn | 单人模式 |
| Your Turn (badge) | Du bist dran | Tu Turno | À votre tour | आपकी बारी | Giliran Anda | あなたのターン | ตาคุณ | Lượt của bạn | 你的回合 |
| Opponent's Turn (badge) | Gegner ist dran | Turno del Oponente | Tour de l'adversaire | प्रतिद्वंद्वी की बारी | Giliran Lawan | 相手のターン | ตาคู่ต่อสู้ | Lượt đối thủ | 对手的回合 |
| You Win! (end screen) | Du gewinnst! | ¡Ganaste! | Vous avez gagné ! | आप जीत गए! | Anda Menang! | あなたの勝ち！ | คุณชนะ! | Bạn thắng! | 你赢了！ |
| Opponent | Gegner | Oponente | Adversaire | प्रतिद्वंद्वी | Lawan | 相手 | คู่ต่อสู้ | Đối thủ | 对手 |
| The correct is (Game Over screen) | Das Richtige ist | Lo correcto es | La bonne réponse est | सही जवाब है | Jawaban yang benar adalah | 正解は | คำตอบที่ถูกต้องคือ | Đáp án đúng là | 正确答案是 |
| Next (button) | Weiter | Siguiente | Suivant | अगला | Lanjut | 次へ | ถัดไป | Tiếp theo | 下一步 |
| Previous (button) | Zurück | Anterior | Précédent | पिछला | Kembali | 前へ | ย้อนกลับ | Trở lại | 上一步 |
| Skip Tour (button) | Überspringen | Saltar Tour | Passer | टूर छोड़ें | Lewati | スキップ | ข้าม | Bỏ qua | 跳过导览 |
| Finish (button) | Fertig | Finalizar | Terminer | समाप्त करें | Selesai | 完了 | สิ้นสุด | Hoàn thành | 完成 |
| Game Over (screen title) | Spiel vorbei | Juego terminado | Jeu Terminé | खेल खत्म | Permainan Berakhir | ゲームオーバー | จบเกม | Kết thúc trò chơi | 游戏结束 |
| Score | Punktzahl | Puntuación | Score | स्कोर | Skor | スコア | คะแนน | Điểm số | 分数 |
| Level | Level | Nivel | Niveau | स्तर | Level | レベル | ระดับ | Cấp độ | 等级 |
| Top score | Bestenliste | Mejor puntuación | Meilleur Score | शीर्ष स्कोर | Skor Tertinggi | 最高スコア | คะแนนสูงสุด | Điểm cao nhất | 最高分 |
| Main Menu | Hauptmenü | Menú principal | Menu Principal | मुख्य मेनू | Menu Utama | メインメニュー | เมนูหลัก | Trang chính | 主菜单 |

## Strings to translate

Each lesson is one card. "Title" is the card heading, "Desc" is the explanation shown first, "Result" is the follow-up shown after the player acts (it replaces the description).


### Regular 1/8 — `RegularWelcome`
_On screen: first practice card; highlights the 3-star lives panel. Player: Next._

| Key | English |
|---|---|
| `tourRuleRegularWelcomeTitle` | Regular Mode |
| `tourRuleRegularWelcomeDesc` | Memorize the number, then type it back before time runs out.\nYou have **3 lives** — lose them all and the game ends. |

### Regular 2/8 — `RegularMemorize`
_On screen: highlights the number shown for a moment, then hidden. Player: watch._

| Key | English |
|---|---|
| `tourRuleRegularMemorizeTitle` | Memorize It |
| `tourRuleRegularMemorizeDesc` | Watch closely — the number flashes on screen for just a moment before it hides. |

### Regular 3/8 — `RegularTypeBack`
_On screen: highlights keypad key "8"; result card highlights the score. Player: tap key._

| Key | English |
|---|---|
| `tourRuleRegularTypeBackTitle` | Type It Back |
| `tourRuleRegularTypeBackDesc` | Now tap the digit you just saw on the keypad. |
| `tourRuleRegularTypeBackResult` | Correct — that's a **point**! |

### Regular 4/8 — `RegularTimer`
_On screen: highlights the timer bar running out; result card highlights the lives. Player: watch._

| Key | English |
|---|---|
| `tourRuleRegularTimerTitle` | Beat the Clock |
| `tourRuleRegularTimerDesc` | Watch the timer bar — if it runs out before you finish typing, you'll lose a life. |
| `tourRuleRegularTimerResult` | Time's up! Running out of time costs you a life, just like a wrong tap. |

### Regular 5/8 — `RegularReset`
_On screen: highlights the Reset key (circular-arrows icon, no text). Player: tap key._

| Key | English |
|---|---|
| `tourRuleRegularResetTitle` | Need a New One? |
| `tourRuleRegularResetDesc` | Tap **Reset** to skip a tricky challenge for a fresh one — but it always costs a life. |

### Regular 6/8 — `RegularLevelUp`
_On screen: highlights keypad key "2"; result card highlights the score/level. Player: tap key._

| Key | English |
|---|---|
| `tourRuleRegularLevelUpTitle` | Leveling Up |
| `tourRuleRegularLevelUpDesc` | Answer enough turns correctly and you'll level up. |
| `tourRuleRegularLevelUpResult` | Level up! Numbers get a little harder from here.\nFinish a level without losing a life to earn a **bonus life**. |

### Regular 7/8 — `RegularGameOver`
_On screen: highlights the last remaining life while the timer runs out. Player: watch._

| Key | English |
|---|---|
| `tourRuleRegularGameOverTitle` | Game Over |
| `tourRuleRegularGameOverDesc` | With only 1 life left, one more miss ends the game for real. Watch what happens. |

### Regular 8/8 — `RegularWrapUp`
_On screen: shown on the Game Over screen; leads into Pick Right. Player: Next._

| Key | English |
|---|---|
| `tourRuleRegularWrapUpTitle` | That's Regular Mode! |
| `tourRuleRegularWrapUpDesc` | Now let's try Pick Right mode — a different way to play. |

### Pick Right 1/5 — `PickRightWelcome`
_On screen: highlights the three answer buttons. Player: Next._

| Key | English |
|---|---|
| `tourRulePickRightWelcomeTitle` | Pick Right Mode |
| `tourRulePickRightWelcomeDesc` | Here you don't type — tap the **right answer**.\nThe other choices are decoys. |

### Pick Right 2/5 — `PickRightCorrect`
_On screen: highlights the correct answer; result card highlights the score. Player: tap answer._

| Key | English |
|---|---|
| `tourRulePickRightCorrectTitle` | Tap the Right One |
| `tourRulePickRightCorrectDesc` | Tap the button you think is correct. |
| `tourRulePickRightCorrectResult` | Correct! You earned a point. |

### Pick Right 3/5 — `PickRightWrong`
_On screen: highlights a wrong answer to tap; result shows the right one. Player: tap answer._

| Key | English |
|---|---|
| `tourRulePickRightWrongTitle` | Oops! |
| `tourRulePickRightWrongDesc` | This time, try tapping a different button. |
| `tourRulePickRightWrongResult` | Wrong pick — the correct answer is highlighted, and you lose a life. |

### Pick Right 4/5 — `PickRightTimer`
_On screen: highlights the fast timer bar; result card is on the Game Over screen. Player: watch._

| Key | English |
|---|---|
| `tourRulePickRightTimerTitle` | This Timer's Faster |
| `tourRulePickRightTimerDesc` | Pick Right mode's timer runs out quickly. Watch what happens if you're too slow. |
| `tourRulePickRightTimerResult` | Time's up again — with no lives left, that's Game Over. |

### Pick Right 5/5 — `PickRightWrapUp`
_On screen: shown on the Game Over screen; leads into Combat. Player: Next._

| Key | English |
|---|---|
| `tourRulePickRightWrapUpTitle` | That's Pick Right! |
| `tourRulePickRightWrapUpDesc` | Now let's try Combat Mode — where you play against a real opponent. |

### Combat 1/5 — `CombatWelcome`
_On screen: highlights the "Your Turn" badge. Player: Next._

| Key | English |
|---|---|
| `tourRuleCombatWelcomeTitle` | Welcome to Combat |
| `tourRuleCombatWelcomeDesc` | You and an opponent take turns.\nThis badge shows **whose turn** it is — as host, you go first. |

### Combat 2/5 — `CombatYourTurn`
_On screen: highlights keypad key "4". Player: tap key._

| Key | English |
|---|---|
| `tourRuleCombatYourTurnTitle` | Your Turn |
| `tourRuleCombatYourTurnDesc` | Tap the digit shown to complete your turn. |

### Combat 3/5 — `CombatOpponentTurn`
_On screen: highlights the opponent panel while the opponent plays. Player: watch._

| Key | English |
|---|---|
| `tourRuleCombatOpponentTurnTitle` | Opponent's Turn |
| `tourRuleCombatOpponentTurnDesc` | Now watch — your opponent takes their turn. |
| `tourRuleCombatOpponentTurnResult` | Your opponent answered correctly! The turn comes right back to you. |

### Combat 4/5 — `CombatWin`
_On screen: opponent runs out of lives; result card is on the "You Win!" screen. Player: watch._

| Key | English |
|---|---|
| `tourRuleCombatWinTitle` | Victory! |
| `tourRuleCombatWinDesc` | Watch what happens when your opponent runs out of lives. |
| `tourRuleCombatWinResult` | You win! Running your opponent out of lives ends the match in your favor. |

### Combat 5/5 — `CombatWrapUp`
_On screen: last card of the whole tour; button says Finish. Player: Finish._

| Key | English |
|---|---|
| `tourRuleCombatWrapUpTitle` | Tutorial Complete! |
| `tourRuleCombatWrapUpDesc` | That's everything — Solo, Pick Right, and Combat. Good luck out there! |

Return the JSON object now.

---

## Regenerating this prompt

The key list, English text, glossary and lesson order come from `lib/helpers/tutorial_localization.dart`, `lib/helpers/tutorial_script.dart`, `lib/localization/app_*.arb` and `../skeleton_core/lib/src/localization/core_*.arb`. Ask Claude to "regenerate the Gemini tour prompt" after changing any of them.

## Merging the answer

Ask Claude to merge it, or check by hand:
- Every language has all keys.
- The `**` and `\n` counts match English.
- Values go into `lib/localization/app_<lang>.arb`.

Then run `flutter gen-l10n` and the tour test (`docs/onboarding-tour/TESTING.md`) to catch overflowing text.
