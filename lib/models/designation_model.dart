class DesignationModel {
  String? response;
  List< DesignationData>? data;

  DesignationModel({this.response, this.data});

  DesignationModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    if (json['data'] != null) {
      data = <DesignationData>[];
      json['data'].forEach((v) {
        data!.add(DesignationData.fromJson(v));
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

class DesignationData {
  int? depId;
  String? depName;
  int? employees;
  int? id;
  String? name;

  DesignationData({this.depId, this.depName, this.employees, this.id, this.name});

  DesignationData.fromJson(Map<String, dynamic> json) {
    depId = json['dep_id'];
    depName = json['dep_name'];
    employees = json['employees'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dep_id'] = depId;
    data['dep_name'] = depName;
    data['employees'] = employees;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
