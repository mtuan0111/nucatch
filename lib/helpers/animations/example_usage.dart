import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'animated_game_wrapper.dart';

/// Example integration of the animation system into Solo Playing Mode
///
/// This demonstrates how to:
/// 1. Wrap your game screen with AnimatedGameWrapper
/// 2. Get widget positions for particle effects
/// 3. Trigger animations based on game events
class AnimationExampleScreen extends StatefulWidget {
  const AnimationExampleScreen({Key? key}) : super(key: key);

  @override
  State<AnimationExampleScreen> createState() => _AnimationExampleScreenState();
}

class _AnimationExampleScreenState extends State<AnimationExampleScreen> {
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  final GlobalKey _scoreKey = GlobalKey();
  final GlobalKey _heartKey = GlobalKey();

  int score = 0;
  int lives = 3;

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapper(
      key: _animationKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Spacer(),
              _buildControls(),
              const SizedBox(height: kSpace4XL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(kPaddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score counter
          Container(
            key: _scoreKey,
            padding: const EdgeInsets.symmetric(
                horizontal: kPaddingL, vertical: kPaddingSM),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Score: $score',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: kFontSizeML,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Lives indicator
          Row(
            key: _heartKey,
            children: List.generate(
              lives,
              (index) => Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.error,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Text(
          'Test Animations',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: kFontSizeXL,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: kPaddingXL),

        // Test Small Firework
        ElevatedButton.icon(
          onPressed: _triggerScoreAnimation,
          icon: const Icon(Icons.star),
          label: const Text('Add Point (Small Firework)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(
                horizontal: kSpace2XL, vertical: kSpaceML),
          ),
        ),
        const SizedBox(height: kSpaceML),

        // Test Large Firework
        ElevatedButton.icon(
          onPressed: _triggerLifeGainAnimation,
          icon: const Icon(Icons.favorite),
          label: const Text('Gain Life (Large Firework)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.symmetric(
                horizontal: kSpace2XL, vertical: kSpaceML),
          ),
        ),
        const SizedBox(height: kSpaceML),

        // Test Screen Shake
        ElevatedButton.icon(
          onPressed: _triggerLifeLostAnimation,
          icon: const Icon(Icons.warning),
          label: const Text('Lost Life (Screen Shake)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            padding: const EdgeInsets.symmetric(
                horizontal: kSpace2XL, vertical: kSpaceML),
          ),
        ),
      ],
    );
  }

  void _triggerScoreAnimation() {
    setState(() {
      score += 10;
    });

    final position = _getWidgetPosition(_scoreKey);
    _animationKey.currentState?.triggers.onAddPoint(position);
  }

  void _triggerLifeGainAnimation() {
    setState(() {
      if (lives < 5) lives++;
    });

    final position = _getWidgetPosition(_heartKey);
    _animationKey.currentState?.triggers.onGainLife(position);
  }

  void _triggerLifeLostAnimation() {
    setState(() {
      if (lives > 0) lives--;
    });

    _animationKey.currentState?.triggers.onLostLife(0.8);
  }

  Offset _getWidgetPosition(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      return position + Offset(box.size.width / 2, box.size.height / 2);
    }
    // Fallback to screen center
    return Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 3,
    );
  }
}

/// Alternative example using the Builder approach
class AnimationExampleBuilderScreen extends StatefulWidget {
  const AnimationExampleBuilderScreen({Key? key}) : super(key: key);

  @override
  State<AnimationExampleBuilderScreen> createState() =>
      _AnimationExampleBuilderScreenState();
}

class _AnimationExampleBuilderScreenState
    extends State<AnimationExampleBuilderScreen> {
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapperBuilder(
      builder: (context, triggers) {
        return Scaffold(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: $score',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: kFontSize2XL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kSpace4XL),
                ElevatedButton(
                  onPressed: () {
                    setState(() => score += 10);
                    triggers.onAddPoint(
                      Offset(
                        MediaQuery.of(context).size.width / 2,
                        MediaQuery.of(context).size.height / 2 - 50,
                      ),
                    );
                  },
                  child: const Text('Add Point'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
