class AttendanceModel {
  int? presentDays;
  int? lateDays;
  int? absentDays;
  int? halfDays;
  Map<String, dynamic>? empStaffing;

  AttendanceModel({
    this.absentDays,
    this.lateDays,
    this.halfDays,
    this.presentDays,
    this.empStaffing,
  });

  /// From API JSON
  factory AttendanceModel.fromApiJson(Map<String, dynamic> json) {
    return AttendanceModel(
      presentDays: json["presentDays"],
      lateDays: json["lateDays"],
      absentDays: json["absentDays"],
      halfDays: json["halfDays"],
      empStaffing: json["emp_staffing"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "presentDays": presentDays,
      "lateDays": lateDays,
      "absentDays": absentDays,
      "halfDays": halfDays,
      "emp_staffing": empStaffing,
    };
  }
}
