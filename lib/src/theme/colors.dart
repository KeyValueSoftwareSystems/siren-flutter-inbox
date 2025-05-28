import 'package:flutter/material.dart';

class SirenAppColors {
  const SirenAppColors._();
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
  static const Color emptyWidgetBellLight = SirenAppColors.grey300;
  static const Color emptyWidgetBadgeLight = SirenAppColors.grey400;
  static const Color emptyWidgetBadgeDark = Color(0xFF63636C);

  static const Color avatarPlaceholderBgLight = Color(0xFFF0F2F5);
  static const Color avatarIconLight = Color(0xFF98A2B3);
  static const Color avatarPlaceholderBgDark = Color(0xFF4C4C4C);
  static const Color avatarIconDark = Color(0xFF999999);

  static const Color dropdownHighlightColor = Color(0xFFF1F2F5);

  // Filter (category) dropdown and badge colors
  static const Color filterIconBorderLight = Color(0xFFE0E0E0);
  static const Color filterBadgeLight = Color(0xFFD32F2F);
  static const Color filterDropdownBackgroundLight = Color(0xFFFFFFFF);
  static const Color filterCheckboxCheckedLight = Color(0xFFFF7043);
  static const Color filterCheckboxUncheckedLight = Color(0xFFBDBDBD);

  static const Color filterIconBorderDark = Color(0xFF444444);
  static const Color filterBadgeDark = Color(0xFFD32F2F);
  static const Color filterDropdownBackgroundDark = Color(0xFF232323);
  static const Color filterCheckboxCheckedDark = Color(0xFFFF7043);
  static const Color filterCheckboxUncheckedDark = Color(0xFF888888);
  static const Color menuActionTextColorLight = Color(0xFF101928);
}
