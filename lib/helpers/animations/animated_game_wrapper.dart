import 'package:flutter/material.dart';
import 'particle_system.dart';
import 'screen_shake_controller.dart';
import 'game_animation_triggers.dart';

/// Wrapper widget that adds animation capabilities to your game screen
///
/// Usage:
/// ```dart
/// final animationKey = GlobalKey<AnimatedGameWrapperState>();
///
/// AnimatedGameWrapper(
///   key: animationKey,
///   child: YourGameScreen(),
/// )
///
/// // Trigger animations:
/// animationKey.currentState?.triggers.onAddPoint(position);
/// animationKey.currentState?.triggers.onGainLife(position);
/// animationKey.currentState?.triggers.onLostLife();
/// ```
class AnimatedGameWrapper extends StatefulWidget {
  final Widget child;

  const AnimatedGameWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedGameWrapper> createState() => AnimatedGameWrapperState();
}

class AnimatedGameWrapperState extends State<AnimatedGameWrapper> {
  final ParticleOverlayController _particleController =
      ParticleOverlayController();
  final ScreenShakeController _shakeController = ScreenShakeController();
  late final GameAnimationTriggers triggers;

  @override
  void initState() {
    super.initState();
    triggers = GameAnimationTriggers(
      particleController: _particleController,
      shakeController: _shakeController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShakeWidget(
      controller: _shakeController,
      child: ParticleOverlay(
        controller: _particleController,
        shakeController: _shakeController,
        child: widget.child,
      ),
    );
  }
}

/// Alternative builder-based approach for easier access to triggers
///
/// Usage:
/// ```dart
/// AnimatedGameWrapperBuilder(
///   builder: (context, triggers) {
///     return YourGameScreen(
///       onScorePoint: () => triggers.onAddPoint(scorePosition),
///       onGainLife: () => triggers.onGainLife(heartPosition),
///       onLostLife: () => triggers.onLostLife(),
///     );
///   },
/// )
/// ```
class AnimatedGameWrapperBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, GameAnimationTriggers triggers)
      builder;

  const AnimatedGameWrapperBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<AnimatedGameWrapperBuilder> createState() =>
      _AnimatedGameWrapperBuilderState();
}

class _AnimatedGameWrapperBuilderState
    extends State<AnimatedGameWrapperBuilder> {
  final ParticleOverlayController _particleController =
      ParticleOverlayController();
  final ScreenShakeController _shakeController = ScreenShakeController();
  late final GameAnimationTriggers triggers;

  @override
  void initState() {
    super.initState();
    triggers = GameAnimationTriggers(
      particleController: _particleController,
      shakeController: _shakeController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShakeWidget(
      controller: _shakeController,
      child: ParticleOverlay(
        controller: _particleController,
        shakeController: _shakeController,
        child: widget.builder(context, triggers),
      ),
    );
  }
}
