# Game Animation System

A high-performance, modular animation system for Flutter games featuring particle effects and screen shake.

## Features

✨ **Small Firework Effect** - Quick particle burst for point scoring  
🎉 **Large Firework Effect** - Celebratory explosion for gaining lives  
📳 **Screen Shake Effect** - Damped harmonic oscillator for impact feedback  
⚡ **60 FPS Performance** - Optimized rendering with CustomPainter  
🎨 **Customizable** - Easy to modify particle colors, sizes, and behaviors

## Quick Start

### 1. Wrap Your Game Screen

**Option A: Using GlobalKey**
```dart
final animationKey = GlobalKey<AnimatedGameWrapperState>();

@override
Widget build(BuildContext context) {
  return AnimatedGameWrapper(
    key: animationKey,
    child: YourGameScreen(),
  );
}
```

**Option B: Using Builder (Recommended)**
```dart
@override
Widget build(BuildContext context) {
  return AnimatedGameWrapperBuilder(
    builder: (context, triggers) {
      return YourGameScreen(
        onScorePoint: () => triggers.onAddPoint(scorePosition),
        onGainLife: () => triggers.onGainLife(heartPosition),
        onLostLife: () => triggers.onLostLife(),
      );
    },
  );
}
```

### 2. Trigger Animations

```dart
// Small firework when scoring points
animationKey.currentState?.triggers.onAddPoint(
  Offset(100, 50), // Position of score counter
);

// Large explosion when gaining life
animationKey.currentState?.triggers.onGainLife(
  Offset(screenWidth / 2, screenHeight / 2), // Center of screen
);

// Screen shake when losing life
animationKey.currentState?.triggers.onLostLife(0.8); // Intensity: 0.0 - 1.0
```

## API Reference

### GameAnimationTriggers

| Method | Parameters | Description |
|--------|------------|-------------|
| `onAddPoint(position)` | `Offset position` | Triggers small firework burst (5-8 particles) |
| `onGainLife(position)` | `Offset position` | Triggers large confetti explosion (15-20 particles) |
| `onLostLife([intensity])` | `double intensity` | Triggers screen shake (default: 0.8) |

### Animation Characteristics

**Small Firework (_onAddPoint)**
- Particles: 5-8
- Colors: Yellow, Orange, Amber
- Curve: Curves.easeOutBack
- Duration: ~0.6-0.8s
- Feel: Fast, snappy "pop"

**Large Firework (_onGainLife)**
- Particles: 15-20
- Colors: Pink, Purple, Blue, Cyan, Yellow, Orange
- Curve: Staggered expansion with drift
- Duration: ~1.0-1.5s
- Feel: Grand, celebratory

**Screen Shake (_onLostLife)**
- Algorithm: Damped harmonic oscillator
- Duration: ~0.5s
- Feel: Violent start, quick stabilization
- No layout disruption (uses Transform)

## Architecture

```
animated_game_wrapper.dart
├── ScreenShakeWidget (Transform-based shake)
└── ParticleOverlay (Particle rendering)
    └── Your Game Screen

game_animation_triggers.dart
├── onAddPoint() → ParticleOverlayController
├── onGainLife() → ParticleOverlayController
└── onLostLife() → ScreenShakeController
```

## Performance

- **60 FPS** maintained during animations
- **CustomPainter** for efficient particle rendering
- **Automatic cleanup** of dead particles
- **IgnorePointer** on overlay to prevent input blocking
- **Transform-based** shake (no layout recalculation)

## Customization

### Custom Particle Effects

```dart
// Create your own particle burst
final customParticles = List.generate(10, (i) {
  return Particle(
    position: startPosition,
    velocity: Offset(cos(angle) * speed, sin(angle) * speed),
    color: Colors.green,
    size: 5.0,
    maxLifetime: 1.0,
  );
});

triggers.particleController.trigger(customParticles);
```

### Adjust Shake Intensity

```dart
// Gentle shake
triggers.onLostLife(0.3);

// Medium shake
triggers.onLostLife(0.6);

// Intense shake
triggers.onLostLife(1.0);
```

## Files

- `particle.dart` - Particle model, painter, and factory
- `particle_system.dart` - Particle lifecycle management
- `screen_shake_controller.dart` - Damped harmonic oscillator
- `game_animation_triggers.dart` - Main trigger API
- `animated_game_wrapper.dart` - Integration widgets

## License

Part of the NuCatch game project.
