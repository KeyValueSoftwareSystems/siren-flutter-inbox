import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/theme/colors.dart';

class AppTheme {
  static ThemeData _createThemeData(ColorScheme colorScheme) {
    return ThemeData.from(colorScheme: colorScheme);
  }

  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData.light().colorScheme.copyWith(
          background: AppColors.emptyWidgetBgLightTheme,
          inversePrimary: AppColors.grey500,
          onBackground: AppColors.grey300Complementary,
          onPrimary: AppColors.black100,
          onSecondary: AppColors.avatarPlaceholderBgLight,
          onTertiary: Colors.white,
          outline: AppColors.grey500,
          outlineVariant: AppColors.grey400,
          primary: Colors.white,
          scrim: AppColors.grey500,
          secondary: AppColors.primary200,
          secondaryContainer: AppColors.primary50,
          shadow: AppColors.emptyWidgetBellLight,
          surface: AppColors.emptyWidgetBadgeLight,
          surfaceTint: AppColors.grey300,
          surfaceVariant: AppColors.avatarIconLight,
          tertiary: AppColors.grey700,
          tertiaryContainer: AppColors.red,
        ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          background: AppColors.emptyWidgetBgDarkTheme,
          inversePrimary: AppColors.grey400,
          onBackground: AppColors.grey50,
          onPrimary: Colors.white,
          onSecondary: AppColors.avatarPlaceholderBgDark,
          onTertiary: Colors.white,
          outline: AppColors.grey500Complementary,
          outlineVariant: AppColors.grey400Complementary,
          primary: AppColors.black100,
          scrim: AppColors.grey400,
          secondary: AppColors.primary200Complementary,
          secondaryContainer: AppColors.primary50Complementary,
          shadow: AppColors.emptyWidgetBellDark,
          surface: AppColors.emptyWidgetBadgeDark,
          surfaceTint: AppColors.grey300Complementary,
          surfaceVariant: AppColors.avatarIconDark,
          tertiary: AppColors.grey700Complementary,
          tertiaryContainer: AppColors.red,
        ),
  );

  static ThemeData customTheme(
    CustomThemeColors customColors, {
    bool isDarkMode = false,
  }) {
    final baseTheme = isDarkMode ? darkTheme : lightTheme;
    return _createThemeData(
      baseTheme.colorScheme.copyWith(
        inversePrimary:
            customColors.dateColor ?? baseTheme.colorScheme.inversePrimary,
        onPrimary: customColors.iconColor ?? baseTheme.colorScheme.onPrimary,
        onTertiary: customColors.badgeColor ?? baseTheme.colorScheme.onTertiary,
        outline: customColors.clearAllIcon ?? baseTheme.colorScheme.outline,
        outlineVariant:
            customColors.deleteIcon ?? baseTheme.colorScheme.outlineVariant,
        primary: customColors.backgroundColor ?? baseTheme.colorScheme.primary,
        secondary: customColors.primary ?? baseTheme.colorScheme.secondary,
        secondaryContainer: customColors.highlightedCardColor ??
            baseTheme.colorScheme.secondaryContainer,
        surfaceTint:
            customColors.borderColor ?? baseTheme.colorScheme.surfaceTint,
        tertiary: customColors.textColor ?? baseTheme.colorScheme.tertiary,
        tertiaryContainer: customColors.badgeBackgroundColor ??
            baseTheme.colorScheme.tertiaryContainer,
        scrim: customColors.timerIcon ?? baseTheme.colorScheme.scrim,
        onBackground:
            customColors.inboxTitleColor ?? baseTheme.colorScheme.onBackground,
        background: baseTheme.colorScheme.background,
        onSecondary: baseTheme.colorScheme.onSecondary,
        shadow: baseTheme.colorScheme.shadow,
        surface: baseTheme.colorScheme.surface,
        surfaceVariant: baseTheme.colorScheme.surfaceVariant,
      ),
    );
  }
}
