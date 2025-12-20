# Integration Guide: Game Animation System

This guide shows you how to integrate the animation system into your Solo Playing Mode.

## Step 1: Import the Package

Add the import to your game screen file:

```dart
import 'package:your_app/helpers/animations/animated_game_wrapper.dart';
```

## Step 2: Choose Integration Method

### Method A: GlobalKey Approach

Best when you need to trigger animations from outside the widget tree.

```dart
class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapper(
      key: _animationKey,
      child: Scaffold(
        body: YourGameContent(),
      ),
    );
  }

  void _handleScorePoint() {
    // Get score counter position
    final scorePosition = Offset(
      MediaQuery.of(context).size.width - 50,
      50,
    );
    
    _animationKey.currentState?.triggers.onAddPoint(scorePosition);
  }

  void _handleGainLife() {
    // Get heart icon position or use screen center
    final heartPosition = Offset(
      MediaQuery.of(context).size.width / 2,
      100,
    );
    
    _animationKey.currentState?.triggers.onGainLife(heartPosition);
  }

  void _handleLostLife() {
    _animationKey.currentState?.triggers.onLostLife();
  }
}
```

### Method B: Builder Approach (Recommended)

Best when animations are triggered from within the widget tree.

```dart
class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapperBuilder(
      builder: (context, triggers) {
        return BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (state is PointScored) {
              triggers.onAddPoint(state.scorePosition);
            } else if (state is LifeGained) {
              triggers.onGainLife(state.heartPosition);
            } else if (state is LifeLost) {
              triggers.onLostLife();
            }
          },
          child: Scaffold(
            body: YourGameContent(),
          ),
        );
      },
    );
  }
}
```

## Step 3: Get Widget Positions

To trigger particle effects at the correct location, you need widget positions.

### Using GlobalKey for Position

```dart
class ScoreCounter extends StatelessWidget {
  final GlobalKey counterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      key: counterKey,
    );
  }

  Offset getPosition() {
    final RenderBox? box = counterKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.localToGlobal(Offset.zero) + Offset(box.size.width / 2, box.size.height / 2);
    }
    return Offset.zero;
  }
}
```

### Using LayoutBuilder for Position

```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final scorePosition = Offset(
        constraints.maxWidth - 50,
        50,
      );
      
      return YourWidget(
        onScorePoint: () => triggers.onAddPoint(scorePosition),
      );
    },
  );
}
```

## Step 4: Connect to Game Events

### With BLoC Pattern

```dart
BlocListener<TurnBloc, TurnState>(
  listener: (context, state) {
    if (state is CorrectAnswer) {
      // Trigger point animation
      final scorePosition = _getScoreCounterPosition();
      _animationKey.currentState?.triggers.onAddPoint(scorePosition);
    } else if (state is LevelUp) {
      // Trigger life gain animation
      final centerPosition = Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      );
      _animationKey.currentState?.triggers.onGainLife(centerPosition);
    } else if (state is WrongAnswer || state is TimeOut) {
      // Trigger screen shake
      _animationKey.currentState?.triggers.onLostLife();
    }
  },
  child: YourGameScreen(),
)
```

### With Direct Callbacks

```dart
void _onCorrectAnswer() {
  // Update score
  setState(() {
    score += 10;
  });
  
  // Trigger animation
  final scorePosition = Offset(screenWidth - 50, 50);
  _animationKey.currentState?.triggers.onAddPoint(scorePosition);
}

void _onWrongAnswer() {
  // Reduce lives
  setState(() {
    lives -= 1;
  });
  
  // Trigger shake
  _animationKey.currentState?.triggers.onLostLife(0.8);
}
```

## Step 5: Customize Animation Intensity

```dart
// Gentle shake for minor mistakes
triggers.onLostLife(0.3);

// Medium shake for wrong answers
triggers.onLostLife(0.6);

// Intense shake for critical failures
triggers.onLostLife(1.0);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/helpers/animations/animated_game_wrapper.dart';
import 'package:your_app/blocs/turn/turn_bloc.dart';

class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final GlobalKey<AnimatedGameWrapperState> _animationKey = GlobalKey();
  final GlobalKey _scoreKey = GlobalKey();
  final GlobalKey _heartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedGameWrapper(
      key: _animationKey,
      child: BlocListener<TurnBloc, TurnState>(
        listener: _handleGameEvents,
        child: Scaffold(
          body: Column(
            children: [
              _buildHeader(),
              _buildGameArea(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGameEvents(BuildContext context, TurnState state) {
    if (state is CorrectAnswer) {
      _triggerScoreAnimation();
    } else if (state is LevelUp) {
      _triggerLifeGainAnimation();
    } else if (state is WrongAnswer || state is TimeOut) {
      _triggerLifeLostAnimation();
    }
  }

  void _triggerScoreAnimation() {
    final position = _getWidgetPosition(_scoreKey);
    _animationKey.currentState?.triggers.onAddPoint(position);
  }

  void _triggerLifeGainAnimation() {
    final position = _getWidgetPosition(_heartKey);
    _animationKey.currentState?.triggers.onGainLife(position);
  }

  void _triggerLifeLostAnimation() {
    _animationKey.currentState?.triggers.onLostLife(0.8);
  }

  Offset _getWidgetPosition(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      return position + Offset(box.size.width / 2, box.size.height / 2);
    }
    return Offset(MediaQuery.of(context).size.width / 2, 100);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Score: $score', key: _scoreKey),
        Icon(Icons.favorite, key: _heartKey),
      ],
    );
  }

  Widget _buildGameArea() {
    // Your game content
    return Container();
  }
}
```

## Tips

1. **Position Accuracy**: Use GlobalKeys to get exact widget positions for particle effects
2. **Performance**: The system is optimized for 60fps, but avoid triggering multiple effects simultaneously
3. **Timing**: Trigger animations immediately when events occur for best feedback
4. **Intensity**: Adjust shake intensity based on the severity of the event
5. **Testing**: Test on real devices to ensure animations feel responsive

## Troubleshooting

**Particles not appearing:**
- Check that position is within screen bounds
- Ensure AnimatedGameWrapper is wrapping your screen
- Verify triggers are being called

**Shake not working:**
- Confirm ScreenShakeController is initialized
- Check that intensity is > 0.0
- Ensure AnimatedGameWrapper is in the widget tree

**Performance issues:**
- Reduce particle count in particle.dart
- Avoid triggering multiple effects at once
- Check for other heavy operations running simultaneously
