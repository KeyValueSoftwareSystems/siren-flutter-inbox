class UnviewedNotificationsCountModel {
  UnviewedNotificationsCountModel({required this.totalUnviewed});

  factory UnviewedNotificationsCountModel.fromMap(Map<String, dynamic> map) {
    return UnviewedNotificationsCountModel(
      totalUnviewed: map['totalUnviewed'] as int,
    );
  }

  int totalUnviewed;
}
