import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/theme/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData.light().colorScheme.copyWith(
          inversePrimary: Colors.black,
          onPrimary: AppColors.black100,
          onTertiary: Colors.white,
          outline: AppColors.grey500,
          outlineVariant: AppColors.grey400,
          primary: Colors.white,
          secondary: AppColors.primary200,
          secondaryContainer: AppColors.primary50,
          surfaceTint: AppColors.grey300,
          tertiary: AppColors.grey700,
          tertiaryContainer: AppColors.red,
          scrim: AppColors.grey500,
          background: AppColors.emptyWidgetBgLightTheme,
        ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          inversePrimary: AppColors.grey400,
          onPrimary: Colors.white,
          onTertiary: Colors.white,
          outline: AppColors.grey500Complementary,
          outlineVariant: AppColors.grey400Complementary,
          primary: AppColors.black100,
          secondary: AppColors.primary200Complementary,
          secondaryContainer: AppColors.primary50Complementary,
          surfaceTint: AppColors.grey300Complementary,
          tertiary: AppColors.grey700Complementary,
          tertiaryContainer: AppColors.red,
          scrim: AppColors.grey400,
          background: AppColors.emptyWidgetBgDarkTheme,
        ),
  );

  static ThemeData customTheme(
    CustomThemeColors customColors, {
    bool isDarkMode = false,
  }) {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
                  inversePrimary: customColors.dateColor,
                  onPrimary: customColors.iconColor,
                  onTertiary: customColors.badgeColor,
                  outline: customColors.clearAllIcon,
                  outlineVariant: customColors.deleteIcon,
                  primary: customColors.backgroundColor,
                  secondary: customColors.highlightedCardBorderColor,
                  secondaryContainer: customColors.highlightedCardColor,
                  surfaceTint: customColors.borderColor,
                  tertiary: customColors.textColor,
                  tertiaryContainer: customColors.badgeBackgroundColor,
                  scrim: customColors.timerIcon,
                ),
          )
        : ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(
                  inversePrimary: customColors.dateColor,
                  onPrimary: customColors.iconColor,
                  onTertiary: customColors.badgeColor,
                  outline: customColors.clearAllIcon,
                  outlineVariant: customColors.deleteIcon,
                  primary: customColors.backgroundColor,
                  secondary: customColors.highlightedCardBorderColor,
                  secondaryContainer: customColors.highlightedCardColor,
                  surfaceTint: customColors.borderColor,
                  tertiary: customColors.textColor,
                  tertiaryContainer: customColors.badgeBackgroundColor,
                  scrim: customColors.timerIcon,
                ),
          );
  }
}
