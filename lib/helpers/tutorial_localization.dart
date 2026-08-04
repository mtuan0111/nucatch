import 'package:flutter/widgets.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart' show lang;
import 'package:nucatch/helpers/tutorial_script.dart';

/// Maps a [TutorialLessonData.key] to its localized title/description.
/// Dart has no reflection, so this is an explicit switch rather than a
/// dynamic `tourRule${lesson.key}Title` lookup — every lesson added to
/// `tutorial_script.dart` needs a matching case here (and matching
/// `tourRule*` keys in every `lib/localization/app_*.arb`).
String tutorialLessonTitle(BuildContext context, TutorialLessonData lesson) {
  switch (lesson.key) {
    case 'RegularWelcome':
      return lang(context).tourRuleRegularWelcomeTitle;
    case 'RegularLives':
      return lang(context).tourRuleRegularLivesTitle;
    case 'RegularMemorize':
      return lang(context).tourRuleRegularMemorizeTitle;
    case 'RegularTypeBack':
      return lang(context).tourRuleRegularTypeBackTitle;
    case 'RegularScoring':
      return lang(context).tourRuleRegularScoringTitle;
    case 'RegularTimer':
      return lang(context).tourRuleRegularTimerTitle;
    case 'RegularReset':
      return lang(context).tourRuleRegularResetTitle;
    case 'RegularLevelUp':
      return lang(context).tourRuleRegularLevelUpTitle;
    case 'RegularGameOver':
      return lang(context).tourRuleRegularGameOverTitle;
    case 'RegularWrapUp':
      return lang(context).tourRuleRegularWrapUpTitle;
    case 'PickRightWelcome':
      return lang(context).tourRulePickRightWelcomeTitle;
    case 'PickRightOptions':
      return lang(context).tourRulePickRightOptionsTitle;
    case 'PickRightCorrect':
      return lang(context).tourRulePickRightCorrectTitle;
    case 'PickRightWrong':
      return lang(context).tourRulePickRightWrongTitle;
    case 'PickRightTimer':
      return lang(context).tourRulePickRightTimerTitle;
    case 'PickRightWrapUp':
      return lang(context).tourRulePickRightWrapUpTitle;
    case 'CombatWelcome':
      return lang(context).tourRuleCombatWelcomeTitle;
    case 'CombatTurnOrder':
      return lang(context).tourRuleCombatTurnOrderTitle;
    case 'CombatYourTurn':
      return lang(context).tourRuleCombatYourTurnTitle;
    case 'CombatOpponentTurn':
      return lang(context).tourRuleCombatOpponentTurnTitle;
    case 'CombatOpponentLifeLost':
      return lang(context).tourRuleCombatOpponentLifeLostTitle;
    case 'CombatTimer':
      return lang(context).tourRuleCombatTimerTitle;
    case 'CombatWin':
      return lang(context).tourRuleCombatWinTitle;
    case 'CombatWrapUp':
      return lang(context).tourRuleCombatWrapUpTitle;
  }
  return lesson.key;
}

/// Returns the "what just happened" result-beat copy when [phase] is
/// [TutorialPhase.result] and the lesson has one, otherwise the normal
/// explain-phase description.
String tutorialLessonDescription(
  BuildContext context,
  TutorialLessonData lesson,
  TutorialPhase phase,
) {
  final useResult = phase == TutorialPhase.result && lesson.hasResultBeat;

  switch (lesson.key) {
    case 'RegularWelcome':
      return lang(context).tourRuleRegularWelcomeDesc;
    case 'RegularLives':
      return lang(context).tourRuleRegularLivesDesc;
    case 'RegularMemorize':
      return lang(context).tourRuleRegularMemorizeDesc;
    case 'RegularTypeBack':
      return lang(context).tourRuleRegularTypeBackDesc;
    case 'RegularScoring':
      return useResult
          ? lang(context).tourRuleRegularScoringResult
          : lang(context).tourRuleRegularScoringDesc;
    case 'RegularTimer':
      return useResult
          ? lang(context).tourRuleRegularTimerResult
          : lang(context).tourRuleRegularTimerDesc;
    case 'RegularReset':
      return lang(context).tourRuleRegularResetDesc;
    case 'RegularLevelUp':
      return useResult
          ? lang(context).tourRuleRegularLevelUpResult
          : lang(context).tourRuleRegularLevelUpDesc;
    case 'RegularGameOver':
      return lang(context).tourRuleRegularGameOverDesc;
    case 'RegularWrapUp':
      return lang(context).tourRuleRegularWrapUpDesc;
    case 'PickRightWelcome':
      return lang(context).tourRulePickRightWelcomeDesc;
    case 'PickRightOptions':
      return lang(context).tourRulePickRightOptionsDesc;
    case 'PickRightCorrect':
      return useResult
          ? lang(context).tourRulePickRightCorrectResult
          : lang(context).tourRulePickRightCorrectDesc;
    case 'PickRightWrong':
      return useResult
          ? lang(context).tourRulePickRightWrongResult
          : lang(context).tourRulePickRightWrongDesc;
    case 'PickRightTimer':
      return useResult
          ? lang(context).tourRulePickRightTimerResult
          : lang(context).tourRulePickRightTimerDesc;
    case 'PickRightWrapUp':
      return lang(context).tourRulePickRightWrapUpDesc;
    case 'CombatWelcome':
      return lang(context).tourRuleCombatWelcomeDesc;
    case 'CombatTurnOrder':
      return lang(context).tourRuleCombatTurnOrderDesc;
    case 'CombatYourTurn':
      return lang(context).tourRuleCombatYourTurnDesc;
    case 'CombatOpponentTurn':
      return useResult
          ? lang(context).tourRuleCombatOpponentTurnResult
          : lang(context).tourRuleCombatOpponentTurnDesc;
    case 'CombatOpponentLifeLost':
      return useResult
          ? lang(context).tourRuleCombatOpponentLifeLostResult
          : lang(context).tourRuleCombatOpponentLifeLostDesc;
    case 'CombatTimer':
      return useResult
          ? lang(context).tourRuleCombatTimerResult
          : lang(context).tourRuleCombatTimerDesc;
    case 'CombatWin':
      return useResult
          ? lang(context).tourRuleCombatWinResult
          : lang(context).tourRuleCombatWinDesc;
    case 'CombatWrapUp':
      return lang(context).tourRuleCombatWrapUpDesc;
  }
  return '';
}
