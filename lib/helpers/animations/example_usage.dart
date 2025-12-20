import 'package:flutter/material.dart';
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
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Spacer(),
              _buildControls(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score counter
          Container(
            key: _scoreKey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Score: $score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Lives indicator
          Row(
            key: _heartKey,
            children: List.generate(
              lives,
              (index) => const Icon(
                Icons.favorite,
                color: Colors.red,
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
        const Text(
          'Test Animations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Test Small Firework
        ElevatedButton.icon(
          onPressed: _triggerScoreAnimation,
          icon: const Icon(Icons.star),
          label: const Text('Add Point (Small Firework)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),

        // Test Large Firework
        ElevatedButton.icon(
          onPressed: _triggerLifeGainAnimation,
          icon: const Icon(Icons.favorite),
          label: const Text('Gain Life (Large Firework)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),

        // Test Screen Shake
        ElevatedButton.icon(
          onPressed: _triggerLifeLostAnimation,
          icon: const Icon(Icons.warning),
          label: const Text('Lost Life (Screen Shake)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          backgroundColor: Colors.grey[900],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
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
