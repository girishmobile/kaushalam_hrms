class ApplyLeaveModel {
  List<dynamic>? finalLeaves;
  LeaveByEmp? leaveByEmp;
  List<LeaveTypes>? leaveTypes;

  ApplyLeaveModel({this.finalLeaves, this.leaveByEmp, this.leaveTypes});

  factory ApplyLeaveModel.fromApiJson(Map<String, dynamic> json) {
    return ApplyLeaveModel(
      finalLeaves: json['finalLeaves'],
      // leaveByEmp: json['leaveByEmp'] != null
      //     ? LeaveByEmp.fromJson(json['leaveByEmp'])
      //     : null,
      // leaveTypes: json["leaveTypes"] != null
      //     ? (json["leaveTypes"] as List<dynamic>)
      //           .map((e) => LeaveTypes.fromApiJson(e))
      //           .toList()
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (finalLeaves != null) {
      data['finalLeaves'] = finalLeaves!.map((v) => v.toJson()).toList();
    }
    if (leaveByEmp != null) {
      data['leaveByEmp'] = leaveByEmp!.toJson();
    }
    if (leaveTypes != null) {
      data['leaveTypes'] = leaveTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveByEmp {
  int? id;
  String? cl;
  String? pl;
  String? sl;
  String? usedUpl;
  bool? employmentStarted;
  bool? oneYearCompleted;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  dynamic deletedAt;

  LeaveByEmp({
    this.id,
    this.cl,
    this.pl,
    this.sl,
    this.usedUpl,
    this.employmentStarted,
    this.oneYearCompleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  LeaveByEmp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cl = json['cl'];
    pl = json['pl'];
    sl = json['sl'];
    usedUpl = json['used_upl'];
    employmentStarted = json['employment_started'];
    oneYearCompleted = json['one_year_completed'];
    createdAt = json['created_at'] != null
        ? CreatedAt.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? CreatedAt.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cl'] = cl;
    data['pl'] = pl;
    data['sl'] = sl;
    data['used_upl'] = usedUpl;
    data['employment_started'] = employmentStarted;
    data['one_year_completed'] = oneYearCompleted;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
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

class LeaveTypes {
  int? id;
  String? leavetype;
  String? countType;
  int? count;
  int? maxLeaveMonth;
  int? maxConsecutiveLeaveMonth;
  String? probation;
  String? halfDay;
  String? interveningHoliday;
  String? unusedLeave;
  String? leaveFrequency;
  String? yearlyCount;
  String? specificCount;
  bool? carryForward;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  dynamic deletedAt;

  LeaveTypes({
    this.id,
    this.leavetype,
    this.countType,
    this.count,
    this.maxLeaveMonth,
    this.maxConsecutiveLeaveMonth,
    this.probation,
    this.halfDay,
    this.interveningHoliday,
    this.unusedLeave,
    this.leaveFrequency,
    this.yearlyCount,
    this.specificCount,
    this.carryForward,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  LeaveTypes.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    leavetype = json['leavetype'];
    countType = json['count_type'];
    count = json['count'];
    maxLeaveMonth = json['max_leave_month'];
    maxConsecutiveLeaveMonth = json['max_consecutive_leave_month'];
    probation = json['probation'];
    halfDay = json['half_day'];
    interveningHoliday = json['intervening_holiday'];
    unusedLeave = json['unused_leave'];
    leaveFrequency = json['leave_frequency'];
    yearlyCount = json['yearly_count'];
    specificCount = json['specific_count'];
    carryForward = json['carry_forward'];
    createdAt = json['created_at'] != null
        ? CreatedAt.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? CreatedAt.fromJson(json['updated_at'])
        : null;
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['leavetype'] = leavetype;
    data['count_type'] = countType;
    data['count'] = count;
    data['max_leave_month'] = maxLeaveMonth;
    data['max_consecutive_leave_month'] = maxConsecutiveLeaveMonth;
    data['probation'] = probation;
    data['half_day'] = halfDay;
    data['intervening_holiday'] = interveningHoliday;
    data['unused_leave'] = unusedLeave;
    data['leave_frequency'] = leaveFrequency;
    data['yearly_count'] = yearlyCount;
    data['specific_count'] = specificCount;
    data['carry_forward'] = carryForward;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toJson();
    }
    data['deletedAt'] = deletedAt;
    return data;
  }
}
