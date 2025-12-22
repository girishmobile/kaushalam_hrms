class KpiDetailsModel {
  int? id;
  Date? date;
  dynamic  targetValue;
  dynamic actualValue;
  dynamic remarks;
  Date? createdAt;
  Date? updatedAt;
  dynamic deletedAt;
  bool? isManualUpdate;

  KpiDetailsModel(
      {this.id,
        this.date,
        this.targetValue,
        this.actualValue,
        this.remarks,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isManualUpdate});

  KpiDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    targetValue = json['target_value'];
    actualValue = json['actual_value'];
    remarks = json['remarks'];
    createdAt = json['created_at'] != null
        ? Date.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? Date.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deleted_at'];
    isManualUpdate = json['is_manual_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (date != null) {
      data['date'] = date!.toJson();
    }
    data['target_value'] = targetValue;
    data['actual_value'] = actualValue;
    data['remarks'] = remarks;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deleted_at'] = deletedAt;
    data['is_manual_update'] = isManualUpdate;
    return data;
  }
}

class Date {
  String? date;
  dynamic  timezoneType;
  String? timezone;

  Date({this.date, this.timezoneType, this.timezone});

  Date.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
    return data;
  }
}
