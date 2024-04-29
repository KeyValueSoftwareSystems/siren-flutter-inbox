import 'package:sirenapp_flutter_inbox/src/theme/app_colors.dart';

/// This class represents the theme of the app and handles theme-related functionality.
class SirenAppTheme {
  /// Returns the AppColors object based on the current theme mode
  static AppColors colors({required bool isDarkMode}) {
    if (isDarkMode) {
      return AppColors.darkColorTheme();
    } else {
      return AppColors.lightColorTheme();
    }
  }
}
