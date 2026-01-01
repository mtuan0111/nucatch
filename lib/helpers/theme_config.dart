import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';
import 'animations/particle.dart';

/// Seasonal theme configuration for the app
///
/// **AUTOMATIC THEME SWITCHING:**
/// The app automatically switches themes based on the device date.
/// Themes activate 1 day before the event and deactivate after the event ends.
///
/// **MANUAL OVERRIDE:**
/// To manually set a theme, change `_manualOverride` to a specific ThemeType.
/// Set to `null` for automatic date-based switching.
///
/// Example: `static ThemeType? _manualOverride = ThemeType.christmas;`
///
/// The theme will automatically apply to:
/// - App colors (primary, secondary, tertiary)
/// - Firework particle colors
/// - Snow particles (if enabled)
/// - Fog overlay (if enabled)
/// - Card colors and UI elements
class SeasonalTheme {
  /// Manual theme override - Set to null for automatic date-based switching
  static ThemeType? _manualOverride = null;

  /// Current active theme - Automatically determined by date or manual override
  static ThemeType get current {
    if (_manualOverride != null) return _manualOverride!;
    return _getThemeByDate();
  }

  /// Check if current date is within Lunar New Year period
  /// Lunar New Year (Spring Festival) is on the 1st day of 1st lunar month
  /// Theme activates 1 day before and ends 7 days after
  static bool _isLunarNewYearPeriod(DateTime date) {
    try {
      // Get current lunar date
      final solar = Solar.fromDate(date);
      solar.getLunar(); // Validate lunar date can be calculated

      // Get Lunar New Year date for current year (1st day of 1st month)
      final lunarNewYear = Lunar.fromYmd(date.year, 1, 1);
      final lunarNewYearSolar = lunarNewYear.getSolar();
      final lunarNewYearDate = DateTime(
        lunarNewYearSolar.getYear(),
        lunarNewYearSolar.getMonth(),
        lunarNewYearSolar.getDay(),
      );

      // Check previous year's Lunar New Year (in case we're in early January)
      final prevYearLunarNewYear = Lunar.fromYmd(date.year - 1, 1, 1);
      final prevYearSolar = prevYearLunarNewYear.getSolar();
      final prevYearDate = DateTime(
        prevYearSolar.getYear(),
        prevYearSolar.getMonth(),
        prevYearSolar.getDay(),
      );

      // Activate 1 day before and end 7 days after
      final currentYearStart =
          lunarNewYearDate.subtract(const Duration(days: 1));
      final currentYearEnd = lunarNewYearDate.add(const Duration(days: 7));

      final prevYearStart = prevYearDate.subtract(const Duration(days: 1));
      final prevYearEnd = prevYearDate.add(const Duration(days: 7));

      // Check if date falls within either period
      return (date.isAfter(currentYearStart) &&
              date.isBefore(currentYearEnd)) ||
          (date.isAfter(prevYearStart) && date.isBefore(prevYearEnd)) ||
          date.isAtSameMomentAs(currentYearStart) ||
          date.isAtSameMomentAs(currentYearEnd) ||
          date.isAtSameMomentAs(prevYearStart) ||
          date.isAtSameMomentAs(prevYearEnd);
    } catch (e) {
      // Fallback to approximate dates if lunar calculation fails
      // Typical range: late January to early February
      final month = date.month;
      final day = date.day;
      return (month == 1 && day >= 20) || (month == 2 && day <= 10);
    }
  }

  /// Determine theme based on current date
  static ThemeType _getThemeByDate() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;

    // New Year's Day: Jan 1 (activate Dec 31, end Jan 2)
    if ((month == 12 && day == 31) || (month == 1 && day <= 1)) {
      return ThemeType.newYear;
    }

    // Lunar New Year: Variable (typically late Jan - early Feb)
    // Dynamically calculated based on lunar calendar
    // Activates 1 day before and ends 7 days after Lunar New Year's Day
    if (_isLunarNewYearPeriod(now)) {
      return ThemeType.lunarNewYear;
    }

    // Valentine's Day: Feb 14 (activate Feb 13, end Feb 15)
    if (month == 2 && day >= 13 && day <= 15) {
      return ThemeType.valentine;
    }

    // Holi: Variable (typically March)
    // 2025: Mar 14, activate Mar 13, end Mar 15
    if (month == 3 && day >= 13 && day <= 15) {
      return ThemeType.holi;
    }
    // Earth Day: Apr 22 (activate Apr 21, end Apr 23)
    if (month == 4 && day >= 21 && day <= 23) {
      return ThemeType.earthDay;
    }
    // Easter: Variable (typically late March - April)
    // 2025: Apr 20, activate Apr 19, end Apr 21
    if (month == 4 && day >= 19 && day <= 21) {
      return ThemeType.easter;
    }

    // Pride Month: June (entire month)
    if (month == 6) {
      return ThemeType.pride;
    }

    // Halloween: Oct 31 (activate Oct 30, end Nov 1)
    if ((month == 10 && day >= 30) || (month == 11 && day == 1)) {
      return ThemeType.halloween;
    }

    // Diwali: Variable (typically Oct-Nov)
    // 2025: Oct 20, activate Oct 19, end Oct 24
    if (month == 10 && day >= 19 && day <= 24) {
      return ThemeType.diwali;
    }

    // Hanukkah: Variable (typically December)
    // 2025: Dec 14-22, activate Dec 13, end Dec 23
    if (month == 12 && day >= 13 && day <= 23) {
      return ThemeType.hanukkah;
    }

    // Christmas: Dec 25 (activate Dec 24, end Dec 26)
    if (month == 12 && day >= 24 && day <= 26) {
      return ThemeType.christmas;
    }

    // Kwanzaa: Dec 26 - Jan 1 (activate Dec 26, end Jan 1)
    if ((month == 12 && day >= 26) || (month == 1 && day == 1)) {
      return ThemeType.kwanzaa;
    }

    // Default theme for all other dates
    return ThemeType.defaultTheme;
  }

  /// Get current theme configuration
  static ThemeConfig get config => _themes[current]!;

  /// Available theme configurations
  static final Map<ThemeType, ThemeConfig> _themes = {
    ThemeType.defaultTheme: ThemeConfig(
      name: 'Default',
      primaryColor:
          const Color.fromARGB(255, 0, 174, 90), // Bright green (adjusted)
      secondaryColor: const Color.fromARGB(
          255, 0, 51, 105), // Bright blue (adjusted to match brightness)
      tertiaryColor: const Color(0xFF00AE5A), // Green
      fireworkColors: [
        const Color(0xFFFF6B6B), // Warm red
        const Color(0xFFFF8E53), // Warm orange
        const Color(0xFFFFA726), // Light orange
        const Color(0xFFFFD54F), // Warm yellow
        const Color(0xFFFF7043), // Deep orange
        const Color(0xFFFF5252), // Bright red
        const Color(0xFFFFAB91), // Light coral
        const Color(0xFFFFE082), // Warm gold
      ],
      enableSnow: false,
      enableFog: false,
    ),
    ThemeType.newYear: ThemeConfig(
      name: 'New Year',
      primaryColor: const Color(0xFFFFD54F), // Light gold (adjusted)
      secondaryColor: const Color(
          0xFFEEEEEE), // Very light gray (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFFFFFF), // White
      cardColor: const Color(0xFFE0E0E0), // Light silver for cards
      fireworkColors: [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFC0C0C0), // Silver
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFFA500), // Orange gold
        const Color(0xFFE5E4E2), // Platinum
        const Color(0xFFFFE5B4), // Peach
        const Color(0xFFF0E68C), // Khaki
        const Color(0xFFFFEFD5), // Papaya whip
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.ribbon,
    ),
    ThemeType.lunarNewYear: ThemeConfig(
      name: 'Lunar New Year',
      primaryColor: const Color(0xFFFF5252), // Bright red (adjusted)
      secondaryColor:
          const Color(0xFFFFCA28), // Bright gold (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFF6B6B), // Light red
      cardColor: const Color(0xFFFFD700), // Gold for cards
      fireworkColors: [
        const Color(0xFFFF0000), // Red
        const Color(0xFFFFD700), // Gold
        const Color(0xFFFF6B6B), // Light red
        const Color(0xFFFFE082), // Warm gold
        const Color(0xFFFF4500), // Orange red
        const Color(0xFFFFB700), // Bright gold
        const Color(0xFFFF1744), // Bright red
        const Color(0xFFFFC400), // Yellow gold
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.redEnvelope,
      snowColors: [
        const Color(0xFFD4001D), // Lucky red
        const Color(0xFFDC143C), // Crimson
        const Color(0xFFFF0000), // Bright red
        const Color(0xFFFF1744), // Vivid red
      ],
      fogColors: [
        const Color(0xFFFFD700).withOpacity(0.05), // Gold tint
        const Color(0xFFFF0000).withOpacity(0.02), // Red tint
        const Color(0xFFFFD700).withOpacity(0.05), // Gold tint
      ],
    ),
    ThemeType.valentine: ThemeConfig(
      name: 'Valentine',
      primaryColor: const Color(0xFFFF4081), // Bright pink (adjusted)
      secondaryColor: const Color(
          0xFFFF6090), // Bright pink 2 (adjusted to match brightness)
      tertiaryColor: const Color(0xFFF48FB1), // Light pink
      cardColor: const Color(0xFFFF80AB), // Light pink for cards
      fireworkColors: [
        const Color(0xFFFF1744), // Bright pink/red
        const Color(0xFFE91E63), // Pink
        const Color(0xFFF48FB1), // Light pink
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFF69B4), // Hot pink
        const Color(0xFFFF1493), // Deep pink
        const Color(0xFFFFC0CB), // Pink
        const Color(0xFFFFB6C1), // Light pink
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.heart,
      snowColors: [
        const Color(0xFFFF1744),
        const Color(0xFFE91E63),
        const Color(0xFFF48FB1),
        const Color(0xFFFF69B4),
      ],
      fogColors: [
        const Color(0xFFFF1744).withOpacity(0.03), // Pink fog
        const Color(0xFFFFFFFF).withOpacity(0.02), // White fog
        const Color(0xFFFF1744).withOpacity(0.03), // Pink fog
      ],
    ),
    ThemeType.holi: ThemeConfig(
      name: 'Holi',
      primaryColor: const Color(0xFFFF6090), // Bright pink (adjusted)
      secondaryColor:
          const Color(0xFF4DD0E1), // Bright cyan (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFFD700), // Gold
      cardColor: const Color(0xFFBA68C8), // Light purple for cards
      fireworkColors: [
        const Color(0xFFFF1493), // Deep pink
        const Color(0xFF00CED1), // Turquoise
        const Color(0xFFFFD700), // Gold
        const Color(0xFF32CD32), // Lime green
        const Color(0xFFFF4500), // Orange red
        const Color(0xFF9B59B6), // Purple
        const Color(0xFFFFFF00), // Yellow
        const Color(0xFF00FF00), // Green
      ],
      enableSnow: false,
      enableFog: true,
      fogColors: [
        const Color(0xFFFF1493).withOpacity(0.04), // Pink mist
        const Color(0xFF00CED1).withOpacity(0.03), // Turquoise mist
        const Color(0xFFFFD700).withOpacity(0.04), // Gold mist
      ],
    ),
    ThemeType.easter: ThemeConfig(
      name: 'Easter',
      primaryColor: const Color(0xFFCE93D8), // Light purple (adjusted)
      secondaryColor: const Color(
          0xFFFFF176), // Light yellow (adjusted to match brightness)
      tertiaryColor: const Color(0xFFE6E6FA), // Lavender
      cardColor: const Color(0xFFE6E6FA), // Lavender for cards
      fireworkColors: [
        const Color(0xFF9370DB), // Medium purple
        const Color(0xFFFFEB3B), // Yellow
        const Color(0xFFFFFFFF), // White
        const Color(0xFFE6E6FA), // Lavender
        const Color(0xFFFFC0CB), // Pink
        const Color(0xFF87CEEB), // Sky blue
        const Color(0xFF98FB98), // Pale green
        const Color(0xFFFFE4E1), // Misty rose
      ],
      enableSnow: false,
      enableFog: true,
      fogColors: [
        const Color(0xFF9370DB).withOpacity(0.03),
        const Color(0xFFFFFFFF).withOpacity(0.04),
        const Color(0xFFE6E6FA).withOpacity(0.03),
      ],
    ),
    ThemeType.earthDay: ThemeConfig(
      name: 'Earth Day',
      primaryColor: const Color(0xFF66BB6A), // Bright green (adjusted)
      secondaryColor:
          const Color(0xFF81C784), // Light green (adjusted to match brightness)
      tertiaryColor: const Color(0xFF90EE90), // Light green
      cardColor: const Color(0xFF81C784), // Light green for cards
      fireworkColors: [
        const Color(0xFF228B22), // Forest green
        const Color(0xFF32CD32), // Lime green
        const Color(0xFF90EE90), // Light green
        const Color(0xFF00FF00), // Green
        const Color(0xFF98FB98), // Pale green
        const Color(0xFF8FBC8F), // Dark sea green
        const Color(0xFF3CB371), // Medium sea green
        const Color(0xFF00FA9A), // Medium spring green
      ],
      enableSnow: true, // Falling leaves
      enableFog: true,
      particleShape: ParticleShape.leaf,
      snowColors: [
        const Color(0xFF228B22),
        const Color(0xFF32CD32),
        const Color(0xFF90EE90),
        const Color(0xFF8FBC8F),
      ],
      fogColors: [
        const Color(0xFF228B22).withOpacity(0.03),
        const Color(0xFF90EE90).withOpacity(0.02),
        const Color(0xFF228B22).withOpacity(0.03),
      ],
    ),
    ThemeType.pride: ThemeConfig(
      name: 'Pride',
      primaryColor: const Color(0xFFFF5252), // Bright red (adjusted)
      secondaryColor:
          const Color(0xFF42A5F5), // Bright blue (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFF8C00), // Orange
      cardColor: const Color(0xFF9B59B6), // Purple for cards
      fireworkColors: [
        const Color(0xFFE40303), // Red
        const Color(0xFFFF8C00), // Orange
        const Color(0xFFFFED00), // Yellow
        const Color(0xFF008026), // Green
        const Color(0xFF24408E), // Indigo
        const Color(0xFF732982), // Violet
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFFC0CB), // Pink
      ],
      enableSnow: false,
      enableFog: false,
    ),
    ThemeType.halloween: ThemeConfig(
      name: 'Halloween',
      primaryColor: const Color(0xFFFF9800), // Bright orange (adjusted)
      secondaryColor: const Color(
          0xFFAB47BC), // Bright purple (adjusted to match brightness)
      tertiaryColor: const Color(0xFF424242), // Dark gray (adjusted from black)
      cardColor: const Color(0xFF9C27B0), // Bright purple for cards
      fireworkColors: [
        const Color(0xFFFF6600), // Orange
        const Color(0xFF9B30FF), // Purple
        const Color(0xFF00FF00), // Toxic green
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFF4500), // Dark orange
        const Color(0xFF8B008B), // Dark magenta
        const Color(0xFF32CD32), // Lime green
        const Color(0xFFFFD700), // Gold
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.spider,
      snowColors: [
        const Color(0xFF000000),
        const Color(0xFF2C0056),
        const Color(0xFF4B0082),
      ],
      fogColors: [
        const Color(0xFF9B30FF).withOpacity(0.05), // Purple fog
        const Color(0xFF000000).withOpacity(0.03), // Dark fog
        const Color(0xFF9B30FF).withOpacity(0.05), // Purple fog
      ],
    ),
    ThemeType.diwali: ThemeConfig(
      name: 'Diwali',
      primaryColor: const Color(0xFFFFCA28), // Bright gold (adjusted)
      secondaryColor:
          const Color(0xFFFF6090), // Bright pink (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFF5252), // Bright red
      cardColor: const Color(0xFFFF6090), // Bright magenta for cards
      fireworkColors: [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFFF1493), // Magenta
        const Color(0xFFDC143C), // Crimson
        const Color(0xFFFF4500), // Orange red
        const Color(0xFFFFB700), // Bright gold
        const Color(0xFFFF69B4), // Hot pink
        const Color(0xFFFFA500), // Orange
        const Color(0xFFFFFFFF), // White
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.marigold,
      snowColors: [
        const Color(0xFFFFD700),
        const Color(0xFFFF8C00),
        const Color(0xFFFFA500),
      ],
      fogColors: [
        const Color(0xFFFFD700).withOpacity(0.05), // Gold mist
        const Color(0xFFFF1493).withOpacity(0.03), // Magenta mist
        const Color(0xFFFFD700).withOpacity(0.05), // Gold mist
      ],
    ),
    ThemeType.hanukkah: ThemeConfig(
      name: 'Hanukkah',
      primaryColor: const Color(0xFF42A5F5), // Bright blue (adjusted)
      secondaryColor: const Color(
          0xFFEEEEEE), // Very light gray (adjusted to match brightness)
      tertiaryColor: const Color(0xFFC0C0C0), // Silver
      cardColor: const Color(0xFF42A5F5), // Bright blue for cards
      fireworkColors: [
        const Color(0xFF0047AB), // Cobalt blue
        const Color(0xFFFFFFFF), // White
        const Color(0xFFC0C0C0), // Silver
        const Color(0xFF87CEEB), // Sky blue
        const Color(0xFFE0E0E0), // Light silver
        const Color(0xFF4169E1), // Royal blue
        const Color(0xFFB0C4DE), // Light steel blue
        const Color(0xFFE6E6FA), // Lavender
      ],
      enableSnow: true,
      enableFog: true,
      fogColors: [
        const Color(0xFF0047AB).withOpacity(0.03),
        const Color(0xFFFFFFFF).withOpacity(0.04),
        const Color(0xFF0047AB).withOpacity(0.03),
      ],
      snowColors: [
        Colors.white,
        const Color(0xFFE0F7FF).withOpacity(0.9),
        const Color(0xFFC0C0C0).withOpacity(0.7),
        const Color(0xFF87CEEB).withOpacity(0.6),
      ],
    ),
    ThemeType.christmas: ThemeConfig(
      name: 'Christmas',
      primaryColor: const Color(0xFFEF5350), // Bright red (adjusted)
      secondaryColor: const Color(
          0xFF66BB6A), // Bright green (adjusted to match brightness)
      tertiaryColor: const Color(0xFFFFD700), // Gold
      cardColor: const Color(0xFF66BB6A), // Bright green for cards
      fireworkColors: [
        const Color(0xFFFF0000), // Christmas red
        const Color(0xFF00FF00), // Christmas green
        const Color(0xFFFFD700), // Gold
        const Color(0xFFFFFFFF), // White
        const Color(0xFFFF6B6B), // Light red
        const Color(0xFF90EE90), // Light green
        const Color(0xFFFFE082), // Warm gold
        const Color(0xFFC0C0C0), // Silver
      ],
      enableSnow: true,
      enableFog: true,
      particleShape: ParticleShape.snowflake,
      snowColors: [
        Colors.white,
        Colors.white.withOpacity(0.9),
        Colors.white.withOpacity(0.7),
        const Color(0xFFE0F7FF), // Very light blue
      ],
    ),
    ThemeType.kwanzaa: ThemeConfig(
      name: 'Kwanzaa',
      primaryColor: const Color(0xFF616161), // Medium gray (adjusted)
      secondaryColor:
          const Color(0xFFEF5350), // Bright red (adjusted to match brightness)
      tertiaryColor: const Color(0xFF66BB6A), // Bright green (adjusted)
      cardColor: const Color(0xFF66BB6A), // Bright green for cards
      fireworkColors: [
        const Color(0xFF000000), // Black
        const Color(0xFFDC143C), // Red
        const Color(0xFF228B22), // Green
        const Color(0xFFFFD700), // Gold
        const Color(0xFF8B0000), // Dark red
        const Color(0xFF006400), // Dark green
        const Color(0xFFFF6B6B), // Light red
        const Color(0xFF90EE90), // Light green
      ],
      enableSnow: false,
      enableFog: true,
      fogColors: [
        const Color(0xFFDC143C).withOpacity(0.03),
        const Color(0xFF228B22).withOpacity(0.02),
        const Color(0xFFDC143C).withOpacity(0.03),
      ],
    ),
  };
}

/// Theme types enum
enum ThemeType {
  defaultTheme,
  newYear,
  lunarNewYear,
  valentine,
  holi,
  earthDay,
  easter,
  pride,
  halloween,
  diwali,
  hanukkah,
  christmas,
  kwanzaa,
}

/// Configuration for a specific theme
class ThemeConfig {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color? cardColor;
  final List<Color> fireworkColors;
  final bool enableSnow;
  final bool enableFog;
  final List<Color>? snowColors;
  final List<Color>? fogColors;
  final ParticleShape particleShape;

  const ThemeConfig({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    this.cardColor,
    required this.fireworkColors,
    this.enableSnow = false,
    this.enableFog = false,
    this.snowColors,
    this.fogColors,
    this.particleShape = ParticleShape.circle,
  });

  /// Get colors for ColorScheme
  ColorScheme getColorScheme() {
    // Determine text colors based on background brightness for better contrast
    final onPrimary = _getContrastingTextColor(primaryColor);
    final onSecondary = _getContrastingTextColor(secondaryColor);
    final onTertiary = _getContrastingTextColor(tertiaryColor);
    final surfaceColor = cardColor ?? primaryColor;
    final onSurface = _getContrastingTextColor(surfaceColor);

    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      brightness: _getBrightness(primaryColor),
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onTertiary: onTertiary,
      surface: surfaceColor,
      onSurface: onSurface,
    );
  }

  /// Calculate relative luminance and determine if color is light or dark
  /// Returns dark text for bright backgrounds, white text for dark backgrounds
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate relative luminance (WCAG formula)
    // Note: r, g, b properties return values from 0.0 to 1.0
    final r = backgroundColor.r;
    final g = backgroundColor.g;
    final b = backgroundColor.b;

    // Apply gamma correction
    final rLinear = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    final gLinear = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    final bLinear = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    final luminance = 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;

    // WCAG AA standard for contrast:
    // - Very light colors (luminance > 0.6): use very dark text (almost black)
    // - Light colors (luminance > 0.35): use dark text (black)
    // - Dark colors (luminance <= 0.35): use white text
    // Adjusted thresholds to ensure bright theme colors get dark text
    if (luminance > 0.6) {
      return Colors.black87; // Very dark text for very bright backgrounds
    } else if (luminance > 0.35) {
      return Colors.black; // Dark text for bright backgrounds
    } else {
      return Colors.white; // White text for dark backgrounds
    }
  }

  /// Determine overall brightness of the theme
  Brightness _getBrightness(Color color) {
    // Note: r, g, b properties return values from 0.0 to 1.0
    final r = color.r;
    final g = color.g;
    final b = color.b;

    final rLinear = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    final gLinear = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    final bLinear = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    final luminance = 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;

    // Use same threshold as text color for consistency
    // luminance > 0.35 = light theme, <= 0.35 = dark theme
    return luminance > 0.35 ? Brightness.light : Brightness.dark;
  }

  /// Get fog gradient colors
  List<Color> getFogColors() {
    return fogColors ??
        [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.02),
          Colors.white.withOpacity(0.05),
        ];
  }

  /// Get snow particle colors
  List<Color> getSnowColors() {
    return snowColors ??
        [
          Colors.white,
          Colors.white.withOpacity(0.9),
          Colors.white.withOpacity(0.7),
          const Color(0xFFE0F7FF),
        ];
  }
}
