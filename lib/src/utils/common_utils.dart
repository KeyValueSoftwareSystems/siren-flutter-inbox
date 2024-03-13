String generateElapsedTimeText(DateTime targetTime) {
  final currentTime = DateTime.now();
  final millisecondsDiff = currentTime.difference(targetTime).inMilliseconds;

  final seconds = (millisecondsDiff / 1000).floor();
  final minutes = (seconds / 60).floor();
  final hours = (minutes / 60).floor();
  final days = (hours / 24).floor();
  final years = (days / 365).floor();

  if (millisecondsDiff < 60000) {
    return 'Just now';
  } else if (minutes < 60) {
    return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
  } else if (hours < 24) {
    return hours == 1 ? '1 hour ago' : '$hours hours ago';
  } else if (days < 365) {
    return days == 1 ? '1 day ago' : '$days days ago';
  } else {
    return years == 1 ? '1 year ago' : '$years years ago';
  }
}

String capitalizeString(String input) {
  String capitalizedString = input.split(' ').map(capitalize).join(' ');
  return capitalizedString;
}

String capitalize(String word) {
  return word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);
}
