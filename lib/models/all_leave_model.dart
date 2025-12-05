// ignore_for_file: non_constant_identifier_names

class AllLeaveModel {
  List<MyLeave> all_leaves = [];
  AllLeaveModel({required this.all_leaves});

  /// From API JSON
  factory AllLeaveModel.fromApiJson(Map<String, dynamic> json) {
    return AllLeaveModel(
      all_leaves: (json["data"] as List<dynamic>)
          .map((e) => MyLeave.fromApiJson(e))
          .toList(),
    );
  }
}

class MyLeave {
  int id;
  LeaveDate? leaveDate;
  LeaveDate? leaveEndDate;
  bool? halfDay;
  String? halfDayType;
  String? leaveCount;
  String? status;
  String? reason;
  String? location;
  bool? finalApprove;
  bool? isLeaveWfh;
  dynamic rejectReason;
  UserId? userId;
  LeaveType? leaveType;
  List<LeaveHistory>? leaveHistory;

  MyLeave({
    required this.id,
    this.leaveDate,
    this.leaveEndDate,
    this.halfDay,
    this.leaveCount,
    this.finalApprove,
    this.halfDayType,
    this.isLeaveWfh,
    this.location,
    this.reason,
    this.status,
    this.rejectReason,
    this.userId,
    this.leaveType,
    this.leaveHistory,
  });
  factory MyLeave.fromApiJson(Map<String, dynamic> json) {
    return MyLeave(
      id: json["id"],
      leaveDate: json["leave_date"] != null
          ? LeaveDate.fromJson(json["leave_date"])
          : null,
      leaveEndDate: json["leave_end_date"] != null
          ? LeaveDate.fromJson(json["leave_end_date"])
          : null,
      halfDay: json["half_day"],
      halfDayType: json['half_day_type'],
      leaveCount: json['leave_count'],
      status: json['status'],
      reason: json['reason'],
      location: json['location'],
      finalApprove: json['final_approve'],
      isLeaveWfh: json['is_leave_wfh'] == 1, // FIX
      rejectReason: json['reject_reason'],
      userId: json["user_id"] != null ? UserId.fromJson(json["user_id"]) : null,
      leaveType: json['leave_type'] != null
          ? LeaveType.fromJson(json['leave_type'])
          : null,
      leaveHistory: json["leave_history"] != null
          ? (json["leave_history"] as List<dynamic>)
                .map((e) => LeaveHistory.fromJson(e))
                .toList()
          : [],
    );
  }
}

class LeaveDate {
  String? date;
  int? timezoneType;
  String? timezone;

  LeaveDate({this.date, this.timezoneType, this.timezone});

  LeaveDate.fromJson(Map<String, dynamic> json) {
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

class UserId {
  int? id;
  String? firstname;
  String? lastname;
  String? profileImage;
  UserId({this.id, this.firstname, this.lastname, this.profileImage});
  UserId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['profile_image'] = profileImage;
    return data;
  }
}

class LeaveType {
  int? id;
  String? leavetype;

  LeaveType({this.id, this.leavetype});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leavetype = json['leavetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['leavetype'] = leavetype;
    return data;
  }
}

class LeaveHistory {
  int? id;
  String? msg;
  LeaveDate? createdAt;

  LeaveHistory({this.id, this.msg, this.createdAt});

  LeaveHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    createdAt = json['created_at'] != null
        ? LeaveDate.fromJson(json['created_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['msg'] = msg;
    if (createdAt != null) {
      data['created_at'] = createdAt!.toJson();
    }
    return data;
  }
}
