class AttendaceRecordModel {
  Data? data;
  dynamic  draw;
  dynamic recordsFiltered;
  dynamic recordsTotal;

  AttendaceRecordModel(
      {this.data, this.draw, this.recordsFiltered, this.recordsTotal});

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
  List<DataItem>? data;
  LeaveData? leaveData;

  Data({this.data, this.leaveData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataItem>[];
      json['data'].forEach((v) {
        data!.add(DataItem.fromJson(v));
      });
    }
    leaveData = json['leave_data'] != null
        ? LeaveData.fromJson(json['leave_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (leaveData != null) {
      data['leave_data'] = leaveData!.toJson();
    }
    return data;
  }
}

class DataItem {
  String? entryTime;
  Date? date;
  String? breakTime;
  String? workingTime;
  String? exitTime;
  Staffing? staffing;

  DataItem(
      {this.entryTime,
        this.date,
        this.breakTime,
        this.workingTime,
        this.exitTime,
        this.staffing});

  DataItem.fromJson(Map<String, dynamic> json) {
    entryTime = json['entry_time'];
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    breakTime = json['break_time'];
    workingTime = json['working_time'];
    exitTime = json['exit_time'];
    staffing = json['staffing'] != null
        ? Staffing.fromJson(json['staffing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entry_time'] = entryTime;
    if (date != null) {
      data['date'] = date!.toJson();
    }
    data['break_time'] = breakTime;
    data['working_time'] = workingTime;
    data['exit_time'] = exitTime;
    if (staffing != null) {
      data['staffing'] = staffing!.toJson();
    }
    return data;
  }
}

class Date {
  String? date;
  dynamic timezoneType;
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

class Staffing {
  dynamic hours;
  dynamic  minutes;
  dynamic barData;

  Staffing({this.hours, this.minutes, this.barData});

  Staffing.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    minutes = json['minutes'];
    barData = json['bar_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hours'] = hours;
    data['minutes'] = minutes;
    data['bar_data'] = barData;
    return data;
  }
}

class LeaveData {
  dynamic presentDays;
  dynamic lateDays;
  dynamic lateDaysRatio;
  dynamic halfDays;
  dynamic absentDays;
  dynamic absentDaysRatio;
  RequiredStaffing? requiredStaffing;
  RequiredStaffing? empStaffing;
  String? productivityRatio;
  dynamic officeStaffing;

  LeaveData(
      {this.presentDays,
        this.lateDays,
        this.lateDaysRatio,
        this.halfDays,
        this.absentDays,
        this.absentDaysRatio,
        this.requiredStaffing,
        this.empStaffing,
        this.productivityRatio,
        this.officeStaffing});

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
  dynamic hours;
  dynamic minutes;

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
