class ManagerLeaveModel {
  List<dynamic> todayLeaves;
  List<RecentLeave> recentLeaves;
  int todayLeavesCount;
  List<dynamic> earlyLeaves;
  int earlyLeavesCount;

  ManagerLeaveModel({
    required this.todayLeaves,
    required this.recentLeaves,
    required this.todayLeavesCount,
    required this.earlyLeaves,
    required this.earlyLeavesCount,
  });
  factory ManagerLeaveModel.fromApiJson(Map<String, dynamic> json) {
    return ManagerLeaveModel(
      todayLeaves: json["today_leaves"] ?? [],
      recentLeaves: json["recent_leaves"] == null
          ? []
          : List<RecentLeave>.from(
              json["recent_leaves"].map((x) => RecentLeave.fromApiJson(x)),
            ),
      todayLeavesCount: json["today_leaves_count"] ?? 0,
      earlyLeaves: json["early_leaves"] ?? [],
      earlyLeavesCount: json["early_leaves_count"] ?? 0,
    );
  }
}

class RecentLeave {
  LeaveDetail detail;
  String leavetype;
  int empId;
  String firstname;
  String lastname;
  String profileImage;
  String designation;
  String batch;

  RecentLeave({
    required this.detail,
    required this.leavetype,
    required this.empId,
    required this.firstname,
    required this.lastname,
    required this.profileImage,
    required this.designation,
    required this.batch,
  });

  factory RecentLeave.fromApiJson(Map<String, dynamic> json) {
    return RecentLeave(
      detail: LeaveDetail.fromApiJson(json["0"]),
      leavetype: json["leavetype"] ?? "",
      empId: json["emp_id"] ?? 0,
      firstname: json["firstname"] ?? "",
      lastname: json["lastname"] ?? "",
      profileImage: json["profile_image"] ?? "",
      designation: json["designation"] ?? "",
      batch: json["batch"] ?? "",
    );
  }
}

class LeaveDetail {
  int id;
  dynamic backupEmp;
  DateTime leaveDate;
  DateTime leaveEndDate;
  bool halfDay;
  String halfDayType;
  String leaveCount;
  String status;
  String reason;
  dynamic location;
  bool finalApprove;
  bool isLeaveWfh;
  dynamic rejectReason;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  LeaveDetail({
    required this.id,
    required this.backupEmp,
    required this.leaveDate,
    required this.leaveEndDate,
    required this.halfDay,
    required this.halfDayType,
    required this.leaveCount,
    required this.status,
    required this.reason,
    required this.location,
    required this.finalApprove,
    required this.isLeaveWfh,
    required this.rejectReason,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory LeaveDetail.fromApiJson(Map<String, dynamic> json) {
    return LeaveDetail(
      id: json["id"],
      backupEmp: json["backup_emp"],
      leaveDate: DateTime.parse(json["leave_date"]["date"]),
      leaveEndDate: DateTime.parse(json["leave_end_date"]["date"]),
      halfDay: json["half_day"] ?? false,
      halfDayType: json["half_day_type"] ?? "",
      leaveCount: json["leave_count"] ?? "",
      status: json["status"] ?? "",
      reason: json["reason"] ?? "",
      location: json["location"],
      finalApprove: json["final_approve"] ?? false,
      isLeaveWfh: json["is_leave_wfh"] ?? false,
      rejectReason: json["reject_reason"],
      createdAt: DateTime.parse(json["created_at"]["date"]),
      updatedAt: DateTime.parse(json["updated_at"]["date"]),
      deletedAt: json["deletedAt"],
    );
  }
}
