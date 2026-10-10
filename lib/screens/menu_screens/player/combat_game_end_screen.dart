import 'package:flutter/material.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/widgets/tutorial_overlay.dart';

class CombatGameEndScreen extends StatelessWidget {
  const CombatGameEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: BlocListener<CombatBloc, CombatState>(
                listenWhen: (previous, current) =>
                    (previous.combatStatus != current.combatStatus &&
                        current.combatStatus == CombatStatus.intro) ||
                    (previous.combatStatus != current.combatStatus &&
                        current.combatStatus ==
                            CombatStatus.choosingDifficulty),
                listener: (context, state) {
                  if (state.combatStatus == CombatStatus.intro) {
                    // Navigate to playing screen when restart countdown begins
                    context.read<CombatNavCubit>().showPlaying();
                  } else if (state.combatStatus ==
                      CombatStatus.choosingDifficulty) {
                    if (context.read<CombatBloc>().isHost) {
                      // Host: navigate to difficulty selection screen
                      context.read<CombatNavCubit>().showSetDifficulty();
                    } else {
                      // Guest: navigate to JoinRoom (shows "Waiting for host" with
                      // existing BlocListener that auto-navigates when difficulty arrives)
                      context.read<CombatNavCubit>().showJoinRoom();
                    }
                  }
                },
                child: BlocBuilder<CombatBloc, CombatState>(
                  builder: (context, combatState) {
                    final isWinner = combatState.isWinner ?? false;

                    return CustomScrollView(
                      slivers: [
                        CustomSliverAppBar(
                          titleWidget: Text(
                            isWinner
                                ? lang(context).youWin
                                : lang(context).youLose,
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.displaySmallTitleScreen(context),
                          ),
                          onBackPressed: () {
                            // Reset CombatBloc to fresh initial state
                            context.read<CombatBloc>().add(CombatBlocReset());

                            // Reset CombatNavCubit to initial state
                            context.read<CombatNavCubit>().reset();

                            // Navigate back to select play mode
                            context.read<PlayerNavCubit>().showSelectPlayMode();
                          },
                          expandedHeight: 100,
                        ),
                        SliverToBoxAdapter(
                          child: DeviceWrapper(
                            // Any landscape (not just tablet) switches to the
                            // 2-pane layout, which needs the full screen width.
                            maxWidth:
                                context.isLandscapeOrientation ? 1200 : null,
                            child: _buildGameEndScreen(context, combatState),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const TutorialOverlay(),
        ],
      ),
    );
  }

  Widget _buildGameEndScreen(BuildContext context, CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;
    // Short windows (a 16:9 phone like 1080x1920) can't fit the full-size
    // badge, scoreboard, answer, ready box and both buttons: shrink the
    // decoration and the gaps so Return to Menu stays on screen.
    final compact = MediaQuery.sizeOf(context).height < _kCompactMaxHeight;
    final gap = compact ? kSpaceM : kSpaceXL;

    // Result/ranking display — ranking badge, expected-answer, end reason.
    // Spotlighted by the tutorial's Victory result beat.
    final resultDisplay = Column(
      key: TourKeys.combatResultKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ranking Widget - Winner (position 1) or Loser (position 4)
        RankingSortingWidget(
          position: isWinner ? 1 : 4,
          // Smaller than the old 100: with the scoreboard added, the
          // page has to fit a phone without pushing Return to Menu
          // below the fold.
          size: compact ? _kCompactResultBadgeSize : _kResultBadgeSize,
          childElement: FaIcon(
            isWinner ? FontAwesomeIcons.trophy : FontAwesomeIcons.faceFrown,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: kIconSizeL,
          ),
        ),
        SizedBox(height: gap),

        // Final score — the payoff of the match, so it leads.
        _buildScoreboard(context, combatState),
        SizedBox(height: gap),

        // Expected String Display (secondary to the score)
        if (combatState.expect != null && combatState.expect!.isNotEmpty) ...[
          Text(
            lang(context).theCorrectIs,
            style: AppTextStyles.bodyMediumBold(context),
          ),
          const SizedBox(height: kSpaceXS),
          Builder(builder: (context) {
            // Use synced correctEquationDisplay for pick-right mode
            // This value is the same on both user and opponent screens
            final displayText =
                combatState.correctEquationDisplay ?? combatState.expect!;
            return Text(
              displayText,
              style: AppTextStyles.titleLarge(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          }),
          const SizedBox(height: kSpaceXL),
        ],

        // Game End Reason
        Text(
          _getGameEndReason(context, combatState),
          style: AppTextStyles.titleMediumBold(context),
          textAlign: TextAlign.center,
        ),
      ],
    );

    // Ready-indicators / action buttons — Play Again (or ready-to-restart),
    // then Return to Menu.
    final readyAndActions = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ready indicators section - wrapped in styled container
        if (combatState.isRestartRequested) ...[
          Container(
            padding: const EdgeInsets.all(kPaddingL),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
                topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
                bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
                bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
              ),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildReadyIndicator(
                      context,
                      label: lang(context).you,
                      isReady: combatState.isPlayerReady,
                      compact: compact,
                    ),
                    const SizedBox(width: kSpace4XL),
                    _buildReadyIndicator(
                      context,
                      label: lang(context).opponent,
                      isReady: combatState.isOpponentReady,
                      compact: compact,
                    ),
                  ],
                ),
                SizedBox(height: gap),
                if (!combatState.isPlayerReady)
                  CustomElevatedButton(
                    text:
                        '${coreLang(context).ready} - ${coreLang(context).playAgain}',
                    buttonSize: ButtonSize.small,
                    shapeAt: RoundedWithShapeAt.topRight,
                    // The main action: the app's primary colour, not the
                    // muted tertiary that made it look disabled.
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundBuilder: (context, borderRadius) =>
                        LightningWidget(
                      baseColor: Theme.of(context).primaryColor,
                      seed: 'PlayAgain'.hashCode,
                      borderRadius: borderRadius,
                    ),
                    onPressed: () {
                      context.read<CombatBloc>().add(
                            CombatRestartReady(isReady: true),
                          );
                    },
                  ),
                // Show "Change Difficulty" button for host only
                if (context.read<CombatBloc>().isHost &&
                    !combatState.isPlayerReady) ...[
                  const SizedBox(height: kSpaceM),
                  CustomElevatedButton(
                    text:
                        '${coreLang(context).ready} - ${coreLang(context).difficultySetting}',
                    buttonSize: ButtonSize.small,
                    shapeAt: RoundedWithShapeAt.topRight,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      context.read<CombatBloc>().add(
                            CombatRestartReady(
                              isReady: true,
                              changeDifficulty: true,
                            ),
                          );
                    },
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          CustomElevatedButton(
            text: coreLang(context).playAgain,
            buttonSize: ButtonSize.small,
            shapeAt: RoundedWithShapeAt.topRight,
            backgroundBuilder: (context, borderRadius) => LightningWidget(
              baseColor: Theme.of(context).primaryColor,
              seed: 'PlayAgain'.hashCode,
              borderRadius: borderRadius,
            ),
            onPressed: () {
              context.read<CombatBloc>().add(CombatRestartRequested());
            },
          ),
        ],
        SizedBox(height: gap),

        // Return to menu button at bottom
        CustomElevatedButton(
          text: coreLang(context).returnToMenu,
          buttonSize: ButtonSize.small,
          shapeAt: RoundedWithShapeAt.bottomLeft,
          // Secondary: a darker shade of the primary colour, so it reads
          // as a real button (the flat grey looked disabled) but stays
          // quieter than Play Again.
          backgroundColor:
              Theme.of(context).primaryColor.getDarker(percentage: 25),
          onPressed: () {
            // Reset CombatBloc to fresh initial state
            context.read<CombatBloc>().add(CombatBlocReset());

            // Reset CombatNavCubit to initial state
            context.read<CombatNavCubit>().reset();

            // Navigate back to select play mode
            context.read<PlayerNavCubit>().showSelectPlayMode();
          },
        ),
      ],
    );

    if (context.isLandscapeOrientation) {
      // 2-pane split: result/ranking display on the left, ready-indicators
      // and action buttons on the right.
      return Container(
        padding: const EdgeInsets.all(kPaddingXL),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: resultDisplay),
              const SizedBox(width: kSpaceXL),
              Expanded(child: readyAndActions),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(kPaddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          resultDisplay,
          SizedBox(height: compact ? kSpaceL : kSpace2XL),
          readyAndActions,
        ],
      ),
    );
  }

  /// "You 6 – 4 Opponent": both final scores, the winner's in full white.
  Widget _buildScoreboard(BuildContext context, CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final scoreStyle = AppTextStyles.displaySmallBold(context);

    Widget side(String label, int score, bool won) {
      final color = won ? onPrimary : onPrimary.withValues(alpha: 0.6);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium(context).copyWith(color: color),
          ),
          Text('$score', style: scoreStyle.copyWith(color: color)),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        side(lang(context).you, combatState.point, isWinner),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceXL),
          child: Text(
            '–',
            style: scoreStyle.copyWith(color: onPrimary.withValues(alpha: 0.6)),
          ),
        ),
        side(lang(context).opponent, combatState.opponentScore, !isWinner),
      ],
    );
  }

  Widget _buildReadyIndicator(
    BuildContext context, {
    required String label,
    required bool isReady,
    bool compact = false,
  }) {
    final size = compact ? _kCompactReadyIndicatorSize : _kReadyIndicatorSize;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady
                ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
            border: Border.all(
              color: isReady
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              width: kStrokeWidthMedium,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: kIconSizeM,
            color: isReady
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: kSpaceS),
        Text(
          label,
          style: AppTextStyles.bodyMedium(context),
        ),
        Text(
          isReady ? coreLang(context).ready : coreLang(context).waiting,
          style: AppTextStyles.withColor(
            AppTextStyles.bodySmall(context),
            isReady
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getGameEndReason(BuildContext context, CombatState combatState) {
    final reason = combatState.gameEndReason;

    switch (reason) {
      case GameEndReason.opponentLivesOut:
        return lang(context).opponentRanOutOfLives;
      case GameEndReason.myLivesOut:
        return lang(context).youRanOutOfLives;
      case GameEndReason.opponentDisconnected:
        return lang(context).opponentDisconnected;
      case GameEndReason.timeout:
        return lang(context).youRanOutOfLives; // Timeout is treated as losing
      case GameEndReason.opponentAway:
        return lang(context).opponentWasAway;
      case GameEndReason.myAway:
        return lang(context).youWereAway;
      case null:
        return '';
    }
  }
}

/// The win/lose badge at the top of the result.
const double _kResultBadgeSize = 80;

/// The You / Opponent ready circles.
const double _kReadyIndicatorSize = 56;

/// Below this window height the result uses its compact sizes.
const double _kCompactMaxHeight = 800;

/// The win/lose badge on short windows.
const double _kCompactResultBadgeSize = 56;

/// The ready circles on short windows.
const double _kCompactReadyIndicatorSize = 44;
