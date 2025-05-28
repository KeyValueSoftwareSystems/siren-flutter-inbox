import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:sirenapp_flutter_inbox/src/constants/generics.dart';

/// Generates elapsed time text based on the difference between the target time and the current time.
String generateElapsedTimeText(DateTime targetTime) {
  final currentTime = DateTime.now();
  final millisecondsDiff = currentTime.difference(targetTime).inMilliseconds;

  final seconds = (millisecondsDiff / 1000).floor();
  final minutes = (seconds / 60).floor();
  final hours = (minutes / 60).floor();
  final days = (hours / 24).floor();
  final months = (days / 30).floor();
  final years = (days / 365).floor();

  if (millisecondsDiff < 60000) {
    return 'Just now';
  } else if (minutes < 60) {
    return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
  } else if (hours < 24) {
    return hours == 1 ? '1 hour ago' : '$hours hours ago';
  } else if (days < 30) {
    return days == 1 ? '1 day ago' : '$days days ago';
  } else if (months < 12) {
    return months == 1 ? '1 month ago' : '$months months ago';
  } else {
    return years == 1 ? '1 year ago' : '$years years ago';
  }
}

/// Modifies the provided date string, converts it to a DateTime object, and then returns it as an ISO 8601 string.
String modifyAndConvertToISOString(String dateString) {
  final parsedDateTime = DateTime.parse(dateString);
  final modifiedDateTime = parsedDateTime.add(const Duration(milliseconds: 1));
  final isoString = modifiedDateTime.toIso8601String();

  return isoString;
}

/// Converts the provided date string to a DateTime object and then returns it as an ISO 8601 string.
String convertToISOString(String dateString) {
  final parsedDateTime = DateTime.parse(dateString);
  final isoString = parsedDateTime.toIso8601String();

  return isoString;
}

/// Loads environment variables from the env file and returns them as a map.
Future<Map<String, String>> loadEnv() async {
  try {
    final contents = await rootBundle.loadString(Generics.ENV_PATH);
    final lines =
        contents.split('\n').where((line) => line.isNotEmpty).toList();

    final envVariables = <String, String>{};
    for (final line in lines) {
      final parts = line.split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();

        envVariables[key] = value;
      }
    }

    return envVariables;
  } on PlatformException {
    return {};
  }
}

/// Retrieves the API domain from the loaded environment variables.
Future<String> getApiDomain() async {
  final env = await loadEnv();
  final apiDomain = env['API_DOMAIN'] ?? '';
  return apiDomain;
}
