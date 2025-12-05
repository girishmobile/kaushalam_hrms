// ignore_for_file: non_constant_identifier_names

class EmpNotificationModel {
  int? id;
  String? title;
  String? details;
  bool? isRead;
  NotiDate? createdAt;
  NotiDate? updatedAt;
  dynamic deletedAt;

  EmpNotificationModel({
    this.id,
    this.title,
    this.details,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory EmpNotificationModel.fromJson(Map<String, dynamic> json) {
    return EmpNotificationModel(
      id: json["id"],
      title: json["title"],
      details: json["details"],
      isRead: json["is_read"],
      createdAt: json["created_at"] != null
          ? NotiDate.fromJson(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? NotiDate.fromJson(json["updated_at"])
          : null,
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["title"] = title;
    data["details"] = details;
    data["is_read"] = isRead;
    if (createdAt != null) data["created_at"] = createdAt!.toJson();
    if (updatedAt != null) data["updated_at"] = updatedAt!.toJson();
    data["deletedAt"] = deletedAt;
    return data;
  }
}

class NotiDate {
  String? date;
  int? timezoneType;
  String? timezone;

  NotiDate({this.date, this.timezone, this.timezoneType});

  factory NotiDate.fromJson(Map<String, dynamic> json) {
    return NotiDate(
      date: json["date"],
      timezoneType: json["timezone_type"],
      timezone: json["timezone"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["date"] = date;
    data["timezone_type"] = timezoneType;
    data["timezone"] = timezone;
    return data;
  }
}
