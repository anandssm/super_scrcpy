import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme({
    Color accent = const Color(0xFF00D2FF),
    ColorScheme? systemScheme,
  }) {
    final colorScheme =
        systemScheme ??
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
          onError: Colors.white,
        ).copyWith(primary: accent);

    final primary = colorScheme.primary;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppDimens.fontHeading,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: AppDimens.fontTitle,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            fontSize: AppDimens.fontXxl,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: AppDimens.fontXl,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: AppDimens.fontMd,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: AppDimens.fontSm,
            fontWeight: FontWeight.w400,
            color: AppColors.textHint,
          ),
          labelLarge: TextStyle(
            fontSize: AppDimens.fontMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            fontSize: AppDimens.fontSm,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(
            color: primary,
            width: AppDimens.inputBorderWidth,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: AppDimens.fontMd,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimens.fontMd,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, AppDimens.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.xxl,
            vertical: AppDimens.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimens.fontMd,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          minimumSize: const Size(0, AppDimens.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.xxl,
            vertical: AppDimens.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppDimens.iconLg,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceHighlight,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          border: Border.all(color: AppColors.borderLight),
        ),
        textStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimens.fontSm,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return AppColors.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.3);
          }
          return AppColors.surfaceHighlight;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: AppColors.surfaceHighlight,
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.1),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: AppColors.textHint, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.lg,
            vertical: AppDimens.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceHighlight,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimens.fontMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        ),
        titleTextStyle: const TextStyle(
          fontSize: AppDimens.fontXl,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
