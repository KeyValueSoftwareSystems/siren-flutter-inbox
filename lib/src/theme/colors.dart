import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  //light mode colors
  static const Color primary200 = Color(0xFFFA9874);
  static const Color primary400 = Color(0xFFF56630);
  static const Color primary50 = Color(0xFFFFECE5);
  static const Color grey300 = Color(0xFFD0D5DD);
  static const Color grey400 = Color(0xFF98A2B3);
  static const Color grey500 = Color(0xFF667185);
  static const Color grey700 = Color(0xFF344054);
  static const Color red = Color(0xFFFF0000);

  //dark mode colors
  static const Color primary200Complementary = Color(0xFFFA9874);
  static const Color primary50Complementary = Color(0XFF2E2D30);
  static const Color grey300Complementary = Color(0xFF344054);
  static const Color grey400Complementary = Color(0xFFE0D7D5);
  static const Color grey500Complementary = Color(0XFFD0D5DD);
  static const Color grey700Complementary = Colors.white;
  static const Color black100 = Color(0xFF232326);
  static const Color grey50 = Color(0xFFF9FAFB);

  //empty state
  static const Color emptyWidgetBgLightTheme = Color(0xFFF7F9FC);
  static const Color emptyWidgetBgDarkTheme = Color(0xFF38383D);
  static const Color emptyWidgetBellDark = Color(0xFF5E5E6A);
  static const Color emptyWidgetBellLight = AppColors.grey300;
  static const Color emptyWidgetBadgeLight = AppColors.grey400;
  static const Color emptyWidgetBadgeDark = Color(0xFF63636C);

  static const Color avatarPlaceholderBg = Color(0xFFF0F2F5);
  static const Color avatarIcon = Color(0xFF98A2B3);
}
