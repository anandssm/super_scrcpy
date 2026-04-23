import 'package:flutter/material.dart';

class AccentColorPreset {
  final String name;
  final Color color;
  const AccentColorPreset(this.name, this.color);
}

class AppColors {
  AppColors._();

  static const List<AccentColorPreset> accentPresets = [
    AccentColorPreset('Cyan', Color(0xFF00D2FF)),
    AccentColorPreset('Purple', Color(0xFF6C5CE7)),
    AccentColorPreset('Blue', Color(0xFF2196F3)),
    AccentColorPreset('Teal', Color(0xFF009688)),
    AccentColorPreset('Green', Color(0xFF4CAF50)),
    AccentColorPreset('Lime', Color(0xFFCDDC39)),
    AccentColorPreset('Orange', Color(0xFFFF9800)),
    AccentColorPreset('Pink', Color(0xFFE91E63)),
    AccentColorPreset('Red', Color(0xFFF44336)),
    AccentColorPreset('Indigo', Color(0xFF3F51B5)),
    AccentColorPreset('Amber', Color(0xFFFFC107)),
    AccentColorPreset('Deep Purple', Color(0xFF673AB7)),
  ];

  static const Color defaultAccent = Color(0xFF00D2FF);

  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7CF6);
  static const Color primaryDark = Color(0xFF5A4BD1);

  static const Color accent = Color(0xFF00D2FF);
  static const Color accentLight = Color(0xFF55E0FF);
  static const Color accentDark = Color(0xFF00A8CC);

  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55D4B8);
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFF9999);
  static const Color warning = Color(0xFFFFC048);
  static const Color warningLight = Color(0xFFFFD88A);

  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF232342);
  static const Color surfaceHighlight = Color(0xFF2D2D50);
  static const Color cardBg = Color(0xFF16213E);

  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color textHint = Color(0xFF6B6B8A);
  static const Color textDisabled = Color(0xFF4A4A65);

  static const Color border = Color(0xFF2A2A45);
  static const Color borderLight = Color(0xFF3A3A5C);
  static const Color borderFocus = Color(0xFF6C5CE7);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF00D2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF232342), Color(0xFF1A1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF6C5CE7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color deviceConnected = Color(0xFF00B894);
  static const Color deviceDisconnected = Color(0xFFFF6B6B);
  static const Color deviceWifi = Color(0xFF00D2FF);
  static const Color deviceUsb = Color(0xFFFFC048);

  static LinearGradient accentSeedGradient(Color accentSeed) => LinearGradient(
    colors: [accentSeed, accentSeed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
