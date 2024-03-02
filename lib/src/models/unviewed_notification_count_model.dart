class UnviewedNotificationsCountModel {
  UnviewedNotificationsCountModel({required this.totalUnviewed});

  factory UnviewedNotificationsCountModel.fromJson(Map<String, dynamic> map) {
    return UnviewedNotificationsCountModel(
      totalUnviewed: map['totalUnviewed'] !=null ? map['totalUnviewed'] as int : 0,
    );
  }

  int totalUnviewed;
}
