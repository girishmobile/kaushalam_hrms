class DepartmentModel {
  String? response;
  List<Data>? data;

  DepartmentModel({this.response, this.data});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = response;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  dynamic  deletedAt;
  int? employees;

  Data(
      {this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.employees});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'] != null
        ? CreatedAt.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? CreatedAt.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
    employees = json['employees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    data['employees'] = employees;
    return data;
  }
}

class CreatedAt {
  String? date;
  int? timezoneType;
  String? timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
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
