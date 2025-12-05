class AttendaceRecordModel {
  Data? data;
  int? draw;
  int? recordsFiltered;
  int? recordsTotal;

  AttendaceRecordModel({
    this.data,
    this.draw,
    this.recordsFiltered,
    this.recordsTotal,
  });

  AttendaceRecordModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['draw'] = draw;
    data['recordsFiltered'] = recordsFiltered;
    data['recordsTotal'] = recordsTotal;
    return data;
  }
}

class Data {
  List<dynamic>? data;
  LeaveData? leaveData;

  Data({this.data, this.leaveData});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? List<dynamic>.from(json['data']) : null;

    leaveData = json['leave_data'] != null
        ? LeaveData.fromJson(json['leave_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    if (data != null) {
      dataMap['data'] = data;
    }
    if (leaveData != null) {
      dataMap['leave_data'] = leaveData!.toJson();
    }
    return dataMap;
  }
}

class LeaveData {
  int? presentDays;
  int? lateDays;
  int? lateDaysRatio;
  int? halfDays;
  int? absentDays;
  int? absentDaysRatio;
  RequiredStaffing? requiredStaffing;
  RequiredStaffing? empStaffing;
  String? productivityRatio;
  int? officeStaffing;

  LeaveData({
    this.presentDays,
    this.lateDays,
    this.lateDaysRatio,
    this.halfDays,
    this.absentDays,
    this.absentDaysRatio,
    this.requiredStaffing,
    this.empStaffing,
    this.productivityRatio,
    this.officeStaffing,
  });

  LeaveData.fromJson(Map<String, dynamic> json) {
    presentDays = json['presentDays'];
    lateDays = json['lateDays'];
    lateDaysRatio = json['lateDaysRatio'];
    halfDays = json['halfDays'];
    absentDays = json['absentDays'];
    absentDaysRatio = json['absentDaysRatio'];
    requiredStaffing = json['required_staffing'] != null
        ? RequiredStaffing.fromJson(json['required_staffing'])
        : null;
    empStaffing = json['emp_staffing'] != null
        ? RequiredStaffing.fromJson(json['emp_staffing'])
        : null;
    productivityRatio = json['productivity_ratio'];
    officeStaffing = json['office_staffing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['presentDays'] = presentDays;
    data['lateDays'] = lateDays;
    data['lateDaysRatio'] = lateDaysRatio;
    data['halfDays'] = halfDays;
    data['absentDays'] = absentDays;
    data['absentDaysRatio'] = absentDaysRatio;
    if (requiredStaffing != null) {
      data['required_staffing'] = requiredStaffing!.toJson();
    }
    if (empStaffing != null) {
      data['emp_staffing'] = empStaffing!.toJson();
    }
    data['productivity_ratio'] = productivityRatio;
    data['office_staffing'] = officeStaffing;
    return data;
  }
}

class RequiredStaffing {
  int? hours;
  int? minutes;

  RequiredStaffing({this.hours, this.minutes});

  RequiredStaffing.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    minutes = json['minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hours'] = hours;
    data['minutes'] = minutes;
    return data;
  }
}
