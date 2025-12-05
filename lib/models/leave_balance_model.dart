// ignore_for_file: non_constant_identifier_names

class LeaveBalanceModel {
  List<EmpLeaveBalance> emp_leave_balance = [];
  LeaveBalanceModel({required this.emp_leave_balance});

  /// From API JSON
  factory LeaveBalanceModel.fromApiJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      emp_leave_balance: (json["data"] as List<dynamic>)
          .map((e) => EmpLeaveBalance.fromApiJson(e))
          .toList(),
    );
  }
}

class EmpLeaveBalance {
  dynamic id;
  dynamic emp_id;
  String firstname;
  String lastname;
  String? profile_image;
  bool user_exit_status;
  dynamic balance;
  dynamic cl;
  dynamic pl;
  dynamic sl;
  dynamic used_upl;
  EmpLeaveBalance({
    required this.id,
    required this.emp_id,
    required this.firstname,
    required this.lastname,
    this.profile_image,
    required this.user_exit_status,
    required this.balance,
    required this.pl,
    required this.cl,
    required this.sl,
    required this.used_upl,
  });
  factory EmpLeaveBalance.fromApiJson(Map<String, dynamic> json) {
    return EmpLeaveBalance(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      profile_image: json["profile_image"],
      emp_id: json["emp_id"],
      user_exit_status: json["user_exit_status"],
      balance: json["balance"],
      cl: json["cl"],
      pl: json["pl"],
      sl: json["sl"],
      used_upl: json["used_upl"],
    );
  }
}
