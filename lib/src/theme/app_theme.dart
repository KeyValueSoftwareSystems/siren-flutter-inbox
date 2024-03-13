import 'package:flutter/material.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/theme/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: Colors.white,
          secondary: AppColors.primary200,
          secondaryContainer: AppColors.primary50,
          surfaceTint: AppColors.grey300,
          outlineVariant: AppColors.grey400,
          outline: AppColors.grey500,
          tertiary: AppColors.grey700,
          inversePrimary: Colors.black,
          tertiaryContainer: AppColors.primary400,
          onTertiary: Colors.white,
          onPrimary: Colors.white,
        ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.black,
          secondary: AppColors.primary200Complementary,
          secondaryContainer: AppColors.primary50Complementary,
          surfaceTint: AppColors.grey300Complementary,
          outlineVariant: AppColors.grey400Complementary,
          outline: AppColors.grey500Complementary,
          tertiary: AppColors.grey700Complementary,
          inversePrimary: Colors.white,
          tertiaryContainer: AppColors.primary400,
          onTertiary: Colors.black,
          onPrimary: Colors.black,
        ),
  );

  static ThemeData customTheme(CustomThemeColors customColors) {
    return ThemeData.light().copyWith(
      colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: customColors.backgroundColor,
            secondary: customColors.activeCardBorderColor,
            secondaryContainer: customColors.activeCardColor,
            surfaceTint: customColors.cardBorder,
            outlineVariant: customColors.deleteIconColor,
            outline: customColors.clearAllIconColor,
            tertiary: customColors.textColor,
            inversePrimary: customColors.inverseBackground,
            tertiaryContainer: customColors.badgeBackgroundColor,
            onTertiary: customColors.badgeColor,
            onPrimary: customColors.iconColor,
          ),
    );
  }
}
