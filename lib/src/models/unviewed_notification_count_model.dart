class UnViewedNotificationsCountModel {
  UnViewedNotificationsCountModel({required this.totalUnViewed});

  factory UnViewedNotificationsCountModel.fromJson(Map<String, dynamic> map) {
    return UnViewedNotificationsCountModel(
      totalUnViewed:
          map['totalUnviewed'] != null ? map['totalUnviewed'] as int : 0,
    );
  }

  int totalUnViewed;
}
