/*
 * EXAMPLE: How to integrate TourSpotlightOverlay into menu_screen.dart
 * This is a reference showing the key changes needed
 * 
 * This file is for documentation purposes only and should not be compiled.
 */

/*
// ============================================
// STEP 1: Add imports at the top of the file
// ============================================
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/widgets/tour_mode_wrapper.dart';

// ============================================
// STEP 2: Add GlobalKey in _MenuScreenState
// ============================================
class _MenuScreenState extends State<MenuScreen> {
  String? version;
  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;
  
  // ADD THIS: GlobalKey for tour spotlight on Start button
  final GlobalKey _startButtonKey = GlobalKey();

  // ... rest of the class
}

// ============================================
// STEP 3: Add key to the Start button
// ============================================
// In the SliverList where menu buttons are created, add key to first button:
child: AnimatedButton(
  context,
  key: index == 0 ? _startButtonKey : null, // ADD THIS LINE
  text: (entry.value['text'] as String).toUpperCase(),
  // ... rest of AnimatedButton properties
)

// ============================================
// STEP 4: Wrap Scaffold in BlocBuilder and Stack
// ============================================
@override
Widget build(BuildContext context) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      // ADD THIS: BlocBuilder for TourBloc
      return BlocBuilder<TourBloc, TourState>(
        builder: (context, tourState) {
          // ADD THIS: Stack to layer spotlight over UI
          return Stack(
            children: [
              // Your existing Scaffold goes here
              Scaffold(
                body: Container(
                  // ... your existing UI
                ),
              ),
              
              // ADD THIS: Spotlight overlay
              if (tourState.isTourActive && 
                  tourState.useSpotlightMode && 
                  tourState.currentTourStep == TourStep.startButton)
                TourModeWrapper.buildSpotlightIfEnabled(
                  tourState: tourState,
                  targetKey: _startButtonKey,
                  title: lang(context).tourStartTitle,
                  description: lang(context).tourStartDesc,
                  allowTargetTap: true,
                  onTargetTap: () {
                    // User tapped Start button
                    menuBloc.add(SelectOption(option: menuArray(context).keys.first));
                    context.read<TourBloc>().add(TourStepCompleted());
                  },
                  skipText: lang(context).tourSkip,
                  previousText: lang(context).tourPrevious,
                  nextText: lang(context).tourNext,
                  finishText: lang(context).tourFinish,
                ) ?? const SizedBox.shrink(),
            ],
          );
        },
      );
    },
  );
}

// ============================================
// THAT'S IT! The spotlight will now show when:
// - Tour is active (tourState.isTourActive)
// - Spotlight mode is enabled (tourState.useSpotlightMode)
// - Current step is startButton
// ============================================

// To expand to other tour steps, add more conditions:
// if (tourState.currentTourStep == TourStep.leaderboard)
//   TourModeWrapper.buildSpotlightIfEnabled(...)
*/
