/// Animation system constants for consistent layout and sizing
/// All size, width, height, and dimension values are centralized here
library;

import 'package:skeleton_core/skeleton_core.dart';

// ============================================================================
// SCREEN SHAKE CONSTANTS
// ============================================================================

/// Screen shake animation duration
const Duration kShakeDuration = Duration(milliseconds: kAnimationDurationSlow);

/// Maximum offset for screen shake effect (in pixels)
const double kShakeMaxOffset = 20.0;

/// Maximum rotation for screen shake effect (in radians, ~3 degrees)
const double kShakeMaxRotation = 0.05;

/// Wind force strength during shake (pixels/s²)
const double kShakeWindStrength = 800.0;

/// Default shake intensity (0.0 to 1.0)
const double kShakeDefaultIntensity = 0.8;

/// Light shake intensity for point scoring
const double kShakeLightIntensity = 0.3;

/// Minimum trauma threshold for shake effects
const double kShakeMinTrauma = 0.01;

// ============================================================================
// PARTICLE SYSTEM CONSTANTS
// ============================================================================

/// Particle animation update rate (assuming ~60fps)
const double kParticleUpdateDelta = 0.016;

/// Particle animation duration
const Duration kParticleAnimationDuration = Duration(seconds: 10);

// Snow particle constants
const int kSnowInitialCount = 30;
const int kSnowReplenishCount = 5;
const int kSnowMinimumCount = 20;
const double kSnowRemovalOffset = 50.0;

// ============================================================================
// PARTICLE SIZE CONSTANTS
// ============================================================================

/// Small burst particle size range (for point scoring)
const double kSmallBurstMinSize = 3.0;
const double kSmallBurstMaxSize = 9.0; // 3.0 + 6.0

/// Large explosion particle size range (for gaining life)
const double kLargeExplosionMinSize = 4.0;
const double kLargeExplosionMaxSize = 7.0; // 4.0 + 3.0

/// Confetti particle size range
const double kConfettiMinSize = 5.0;
const double kConfettiMaxSize = 8.0; // 5.0 + 3.0

/// Snow particle size range
const double kSnowMinSize = 4.0;
const double kSnowMaxSize = 10.0; // 4.0 + 6.0

/// Gold coin particle size range
const double kGoldCoinMinSize = 6.0;
const double kGoldCoinMaxSize = 14.0; // 6.0 + 8.0

// ============================================================================
// PARTICLE VELOCITY CONSTANTS
// ============================================================================

/// Small burst velocity range
const double kSmallBurstMinSpeed = 150.0;
const double kSmallBurstMaxSpeed = 250.0; // 150.0 + 100.0
const double kSmallBurstUpwardBias = -100.0;

/// Large explosion velocity range
const double kLargeExplosionMinSpeed = 200.0;
const double kLargeExplosionMaxSpeed = 350.0; // 200.0 + 150.0
const double kLargeExplosionUpwardBias = -150.0;

/// Confetti velocity range
const double kConfettiMinSpeed = 250.0;
const double kConfettiMaxSpeed = 350.0; // 250.0 + 100.0
const double kConfettiUpwardBias = -200.0;

/// Snow velocity range
const double kSnowMinVerticalSpeed = 20.0;
const double kSnowMaxVerticalSpeed = 50.0; // 20.0 + 30.0
const double kSnowHorizontalDriftRange = 20.0; // ±10

/// Gold coin velocity range
const double kGoldCoinMinVerticalSpeed = 50.0;
const double kGoldCoinMaxVerticalSpeed = 150.0; // 50.0 + 100.0
const double kGoldCoinHorizontalRange = 50.0; // ±25
const double kGoldCoinSpawnSpread = 100.0;
const double kGoldCoinSpawnHeight = 50.0;

// ============================================================================
// PARTICLE LIFETIME CONSTANTS
// ============================================================================

/// Small burst lifetime range (in seconds)
const double kSmallBurstMinLifetime = 0.6;
const double kSmallBurstMaxLifetime = 0.8; // 0.6 + 0.2

/// Large explosion lifetime range (in seconds)
const double kLargeExplosionMinLifetime = 1.0;
const double kLargeExplosionMaxLifetime = 1.5; // 1.0 + 0.5

/// Confetti lifetime range (in seconds)
const double kConfettiMinLifetime = 1.5;
const double kConfettiMaxLifetime = 2.0; // 1.5 + 0.5

/// Snow lifetime range (in seconds)
const double kSnowMinLifetime = 10.0;
const double kSnowMaxLifetime = 15.0; // 10.0 + 5.0

/// Gold coin lifetime range (in seconds)
const double kGoldCoinMinLifetime = 3.0;
const double kGoldCoinMaxLifetime = 5.0; // 3.0 + 2.0

// ============================================================================
// PARTICLE ROTATION CONSTANTS
// ============================================================================

/// Small burst rotation speed range
const double kSmallBurstRotationSpeed = 10.0;

/// Large explosion rotation speed range
const double kLargeExplosionRotationSpeed = 15.0;

/// Confetti rotation speed range
const double kConfettiRotationSpeed = 20.0;

/// Snow rotation speed range
const double kSnowRotationSpeed = 2.0;

/// Gold coin rotation speed range
const double kGoldCoinRotationSpeed = 8.0;

// ============================================================================
// PARTICLE COUNT CONSTANTS
// ============================================================================

/// Default particle count for small burst
const int kSmallBurstDefaultCount = 6;

/// Default particle count for large explosion
const int kLargeExplosionDefaultCount = 18;

/// Default particle count for confetti
const int kConfettiDefaultCount = 20;

/// Default particle count for gold coin rain
const int kGoldCoinDefaultCount = 15;

/// Small burst count variation (60% to 140% of base count)
const double kSmallBurstCountMin = 0.6;
const double kSmallBurstCountMax = 1.4; // 0.6 + 0.8

// ============================================================================
// PARTICLE ANGLE VARIATION CONSTANTS
// ============================================================================

/// Small burst angle variation
const double kSmallBurstAngleVariation = 0.5;

/// Large explosion angle variation
const double kLargeExplosionAngleVariation = 0.3;

/// Confetti angle variation
const double kConfettiAngleVariation = 0.4;

// ============================================================================
// PARTICLE SHAPE DRAWING CONSTANTS
// ============================================================================

/// Base scale divisor for particle shapes
const double kParticleShapeScaleDivisor = 10.0;

/// Glow effect constants
const double kGlowSizeMultiplier = 1.5;
const double kGlowOpacityMultiplier = 0.3;
const double kGlowBlurRadius = 4.0;
const double kGlowIntenseBlurRadius = 8.0;

/// Heart shape scale factors
const double kHeartTopY = 3.0;
const double kHeartLeftX = -5.0;
const double kHeartLeftControlY = -3.0;
const double kHeartBottomX = -10.0;
const double kHeartBottomY = 1.0;
const double kHeartPointY = 10.0;

/// Leaf shape scale factors
const double kLeafTopY = -10.0;
const double kLeafRightControlX = 5.0;
const double kLeafRightControlY = -5.0;
const double kLeafRightX = 8.0;
const double kLeafBottomY = 10.0;
const double kLeafVeinStrokeWidth = 0.5;

/// Ornament shape scale factors
const double kOrnamentBallY = 2.0;
const double kOrnamentBallRadius = 8.0;
const double kOrnamentCapX = -2.0;
const double kOrnamentCapY = -2.0;
const double kOrnamentCapWidth = 4.0;
const double kOrnamentCapHeight = 4.0;
const double kOrnamentCapOpacity = 0.7;

/// Snowflake shape constants
const int kSnowflakePoints = 6;
const double kSnowflakePointAngle = 60.0;
const double kSnowflakeArmLength = 8.0;
const double kSnowflakeBranchLength = 3.0;
const double kSnowflakeBranchPosition = 0.6;
const double kSnowflakeBranchAngle = 0.5;
const double kSnowflakeStrokeWidth = 0.8;

/// Confetti rectangle dimensions
const double kConfettiWidth = 4.0;
const double kConfettiHeight = 6.0;

/// Gold coin shape constants
const double kGoldCoinRadius = 8.0;
const double kGoldCoinGlowRadius = 10.0;
const double kGoldCoinBorderWidth = 1.0;
const double kGoldCoinShineX = -2.0;
const double kGoldCoinShineY = -2.0;
const double kGoldCoinShineRadius = 2.0;
const double kGoldCoinShineOpacity = 0.6;
const double kGoldCoinInnerRadius = 5.0;
const double kGoldCoinInnerStrokeWidth = 0.5;
const double kGoldCoinInnerOpacity = 0.8;

/// Spider shape constants
const int kSpiderLegCount = 8;
const double kSpiderBodyRadius = 4.0;
const double kSpiderLegLength = 8.0;
const double kSpiderLegAngle = 45.0;
const double kSpiderLegStrokeWidth = 0.6;

/// Cobweb shape constants
const int kCobwebRadialLines = 8;
const double kCobwebLineLength = 10.0;
const double kCobwebInnerRingRadius = 3.0;
const double kCobwebOuterRingRadius = 6.0;
const double kCobwebStrokeWidth = 0.4;
const double kCobwebOpacity = 0.6;

/// Marigold shape constants
const int kMarigoldPetalCount = 8;
const double kMarigoldCenterRadius = 2.0;
const double kMarigoldPetalDistance = 5.0;
const double kMarigoldPetalRadius = 2.0;
const double kMarigoldPetalOpacity = 0.8;

/// Fairy light shape constants
const double kFairyLightBulbRadius = 4.0;
const double kFairyLightGlowRadius = 8.0;
const double kFairyLightGlowOpacity = 0.4;

/// Red envelope dimensions
const double kRedEnvelopeWidth = 10.0;
const double kRedEnvelopeHeight = 14.0;
const double kRedEnvelopeBorderWidth = 0.8;
const double kRedEnvelopeCoinRadius = 2.5;
const double kRedEnvelopeHoleSize = 1.2;
const double kRedEnvelopeLineY = 5.0;
const double kRedEnvelopeLineX = 3.0;
const double kRedEnvelopeCornerX = 4.0;
const double kRedEnvelopeCornerY = 6.0;
const double kRedEnvelopeCornerSize = 0.8;

/// Paper lantern dimensions
const double kPaperLanternWidth = 10.0;
const double kPaperLanternHeight = 12.0;
const double kPaperLanternRadius = 2.0;
const double kPaperLanternLineY = 3.0;
const double kPaperLanternLineX = 5.0;
const double kPaperLanternHookTop = -6.0;
const double kPaperLanternHookBottom = -8.0;
const double kPaperLanternLineWidth = 0.5;
const double kPaperLanternLineOpacity = 0.6;

/// Chinese knot dimensions
const double kChineseKnotOuterY = 6.0;
const double kChineseKnotOuterX = 4.0;
const double kChineseKnotInnerY = 3.0;
const double kChineseKnotInnerX = 2.0;
const double kChineseKnotTasselTop = 6.0;
const double kChineseKnotTasselBottom = 10.0;
const double kChineseKnotStrokeWidth = 0.6;
const double kChineseKnotInnerOpacity = 0.5;

// ============================================================================
// PARTICLE PHYSICS CONSTANTS
// ============================================================================

/// Gravity values for different particle materials (pixels/s²)
const double kGravityVeryLight = 15.0; // Feather
const double kGravityLight = 30.0; // Snowflake, ribbon
const double kGravityMediumLight = 50.0; // Leaf
const double kGravityMedium = 80.0; // Heart, egg
const double kGravityMediumHeavy = 120.0; // Spider
const double kGravityHeavy = 150.0; // Seed, acorn
const double kGravityVeryHeavy = 250.0; // Ornament, gold coin
const double kGravityDefault = 500.0; // Circle (firework)

/// Drag coefficients (air resistance, 0.9-0.99, closer to 1 = less resistance)
const double kDragHigh = 0.99;
const double kDragMediumHigh = 0.98;
const double kDragMedium = 0.97;
const double kDragMediumLow = 0.96;
const double kDragLow = 0.95;
const double kDragVeryLow = 0.94;

/// Sway force values (horizontal drift for light materials)
const double kSwayVeryHigh = 50.0;
const double kSwayHigh = 40.0;
const double kSwayMediumHigh = 35.0;
const double kSwayMedium = 30.0;
const double kSwayMediumLow = 25.0;
const double kSwayLow = 20.0;
const double kSwayVeryLow = 10.0;
const double kSwayMinimal = 5.0;
const double kSwayNone = 0.0;

/// Wind sensitivity calculation constant
const double kWindSensitivityDivisor = 500.0;
const double kWindSensitivityMax = 0.95;

/// Sway calculation constants
const double kSwayFrequency = 0.05;

// ============================================================================
// ROTATION MULTIPLIER CONSTANTS
// ============================================================================

const double kRotationMultiplierVeryHigh = 2.0;
const double kRotationMultiplierHigh = 1.5;
const double kRotationMultiplierMediumHigh = 1.2;
const double kRotationMultiplierDefault = 1.0;
const double kRotationMultiplierMedium = 0.8;
const double kRotationMultiplierMediumLow = 0.7;
const double kRotationMultiplierLow = 0.6;
const double kRotationMultiplierVeryLow = 0.5;
const double kRotationMultiplierMinimal = 0.3;
const double kRotationMultiplierNone = 0.0;
