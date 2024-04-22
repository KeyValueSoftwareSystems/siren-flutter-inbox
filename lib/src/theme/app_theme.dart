import 'package:flutter/material.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/theme/colors.dart';

class AppTheme {
  static ThemeData _createThemeData(ColorScheme colorScheme) {
    return ThemeData.from(colorScheme: colorScheme);
  }

  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primaryContainer: AppColors.emptyWidgetBgLightTheme,
          inversePrimary: AppColors.grey500,
          onPrimaryContainer: AppColors.grey300Complementary,
          onInverseSurface: Colors.white,
          onPrimary: AppColors.black100,
          onSecondary: AppColors.avatarPlaceholderBgLight,
          onTertiary: AppColors.primary200,
          outline: AppColors.grey500,
          outlineVariant: AppColors.grey400,
          primary: Colors.white,
          scrim: AppColors.grey500,
          secondary: AppColors.primary200,
          secondaryContainer: AppColors.primary50,
          shadow: AppColors.emptyWidgetBellLight,
          surface: AppColors.emptyWidgetBadgeLight,
          surfaceTint: AppColors.grey300,
          onTertiaryContainer: AppColors.avatarIconLight,
          tertiary: AppColors.grey700,
          tertiaryContainer: AppColors.red,
        ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primaryContainer: AppColors.emptyWidgetBgDarkTheme,
          inversePrimary: AppColors.grey400,
          onPrimaryContainer: AppColors.grey50,
          onInverseSurface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: AppColors.avatarPlaceholderBgDark,
          onTertiary: AppColors.primary200Complementary,
          outline: AppColors.grey500Complementary,
          outlineVariant: AppColors.grey400Complementary,
          primary: AppColors.black100,
          scrim: AppColors.grey400,
          secondary: AppColors.primary200Complementary,
          secondaryContainer: AppColors.primary50Complementary,
          shadow: AppColors.emptyWidgetBellDark,
          surface: AppColors.emptyWidgetBadgeDark,
          surfaceTint: AppColors.grey300Complementary,
          onTertiaryContainer: AppColors.avatarIconDark,
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
        onPrimary: customColors.notificationIconColor ??
            baseTheme.colorScheme.onPrimary,
        onTertiary: customColors.refreshIndicatorColor ??
            baseTheme.colorScheme.onTertiary,
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
        scrim: customColors.timerIcon ?? baseTheme.colorScheme.scrim,
        primaryContainer: baseTheme.colorScheme.primaryContainer,
        onSecondary: baseTheme.colorScheme.onSecondary,
        shadow: baseTheme.colorScheme.shadow,
        surface: baseTheme.colorScheme.surface,
        onTertiaryContainer: baseTheme.colorScheme.onTertiaryContainer,
        onInverseSurface: baseTheme.colorScheme.onInverseSurface,
        onPrimaryContainer: baseTheme.colorScheme.onPrimaryContainer,
      ),
    )
        .copyWith(
          badgeTheme: baseTheme.badgeTheme.copyWith(
            backgroundColor: customColors.badgeColors?.color ??
                baseTheme.badgeTheme.backgroundColor,
            textColor: customColors.badgeColors?.textColor ??
                baseTheme.badgeTheme.textColor,
          ),
        )
        .copyWith(
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: customColors.inboxHeaderColors?.background ??
                baseTheme.appBarTheme.backgroundColor,
            foregroundColor:
                customColors.inboxHeaderColors?.headerActionColor ??
                    baseTheme.appBarTheme.foregroundColor,
            shadowColor: customColors.inboxHeaderColors?.borderColor ??
                baseTheme.appBarTheme.shadowColor,
          ),
        )
        .copyWith(
          cardTheme: baseTheme.cardTheme.copyWith(
            color: customColors.cardColors?.background, //  Card background
            shadowColor: customColors.cardColors?.borderColor, //  Card border
            surfaceTintColor:
                customColors.cardColors?.titleColor, //  Card title color
          ),
        )
        .copyWith(
          bannerTheme: baseTheme.bannerTheme.copyWith(
            backgroundColor:
                customColors.cardColors?.subtitleColor, // Card sub title color
            surfaceTintColor: customColors
                .cardColors?.descriptionColor, // Card description color
            dividerColor: customColors
                .inboxHeaderColors?.titleColor, // Header title color
          ),
        );
  }
}
