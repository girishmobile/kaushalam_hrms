class LeaveSummary {
  int pending;
  int accept;
  int cancel;
  int reject;
  int all;
  LeaveSummary({
    required this.pending,
    required this.accept,
    required this.cancel,
    required this.reject,
    required this.all,
  });

  /// From API JSON
  factory LeaveSummary.fromApiJson(Map<String, dynamic> json) {
    return LeaveSummary(
      pending: json["Pending"],
      accept: json["Accept"],
      cancel: json["Cancel"],
      reject: json["Reject"],
      all: json["All"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "Pending": pending,
      "Accept": accept,
      "Cancel": cancel,
      "Reject": reject,
      "All": all,
    };
  }
}

class LeaveBalance {
  int id;
  double cl;
  double pl;
  double sl;
  double usedUpl;
  double totalLeaves;

  LeaveBalance({
    required this.id,
    required this.cl,
    required this.pl,
    required this.sl,
    required this.usedUpl,
    required this.totalLeaves,
  });

  /// From API JSON
  factory LeaveBalance.fromApiJson(Map<String, dynamic> json) {
    return LeaveBalance(
      id: json["id"],
      cl: _toDouble(json["cl"]),
      pl: _toDouble(json["pl"]),
      sl: _toDouble(json["sl"]),
      usedUpl: _toDouble(json["used_upl"]),
      totalLeaves: _toDouble(json["total_leaves"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "cl": cl,
      "pl": pl,
      "sl": sl,
      "used_upl": usedUpl,
      "total_leaves": totalLeaves,
    };
  }

  // Helpers
  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
