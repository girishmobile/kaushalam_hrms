import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/attendace_record_model.dart';

class AttendanceProvider extends ChangeNotifier /*  */ {
  String _selectedDateRange = '';
  String get selectedDateRange => _selectedDateRange;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //data
  AttendaceRecordModel? _attendanceRecordModel;
  AttendaceRecordModel? get attendanceRecordModel => _attendanceRecordModel;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setSelectedDateRange(String value) {
    _selectedDateRange = value;
    notifyListeners();
  }

  Future<void> initializeTodayAttendance() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    setSelectedDateRange("Today");
    await _fetchAttendance(start, end);
  }

  Future<void> _fetchAttendance(DateTime start, DateTime end) async {
    _setLoading(true);
    Map<String, dynamic> body = {
      "dataTablesParameters": {
        "draw": 1,
        "columns": [
          {
            "data": 0,
            "name": "date",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 1,
            "name": "entry_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 2,
            "name": "exit_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 3,
            "name": "break_time",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
          {
            "data": 4,
            "name": "working_hours",
            "searchable": true,
            "orderable": false,
            "search": {"value": "", "regex": false},
          },
        ],
        "order": [],
        "start": 0,
        "length": 10,
        "search": {"value": "", "regex": false},
      },
      "dateRange": {
        "start_date": start.toIso8601String(),
        "end_date": end.toIso8601String(),
      },
    };
    try {
      final response = await callApi(
        url: ApiConfig.getAttendanceUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _attendanceRecordModel = AttendaceRecordModel.fromJson(
          json.decode(response),
        );
        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }

  List<Map<String, dynamic>> get attendanceGridItems {
    if (_attendanceRecordModel?.data?.leaveData == null) return [];

    final leave = _attendanceRecordModel?.data?.leaveData;

    return [
      {
        "title": "Days",
        "value": leave?.presentDays ?? 0,
        "desc": '',
        "color": const Color(0xFF4CAF50), // Green
        "icon": Icons.calendar_month_outlined,
      },
      {
        "title": "Absent",
        "value": leave?.absentDays ?? 0,
        "desc": '',
        "color": const Color(0xFFF44336), // Red
        "icon": Icons.remove_circle_outline,
      },
      {
        "title": "Late",
        "value": (leave?.lateDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
        "color": const Color(0xFFFF9800), // Orange
        "icon": Icons.access_time_outlined,
      },
      {
        "title": "Half Days",
        "value": leave?.halfDays ?? 0,
        "desc": '',
        "color": const Color(0xFF9C27B0), // Purple
        "icon": Icons.timelapse_outlined,
      },
      {
        "title": "Absent Days Ratio",
        "value": (leave?.absentDaysRatio ?? 0).toInt(),
        "desc": '% (0 Days)',
        "color": const Color(0xFF03A9F4), // Light Blue
        "icon": Icons.pie_chart_outline,
      },
      {
        "title": "Productivity Ratio",
        "value": int.tryParse('${leave?.productivityRatio ?? 0}') ?? 0,
        "desc": '.00%',
        "color": const Color(0xFF009688), // Teal
        "icon": Icons.trending_up,
      },
      {
        "title": "Office Staffing",
        "value": leave?.officeStaffing ?? 0,
        "desc": '',
        "color": const Color(0xFF673AB7), // Deep Purple
        "icon": Icons.groups_outlined,
      },
      if (leave?.requiredStaffing != null)
        {
          "title": "Required Staffing",
          "value":
              ((leave?.requiredStaffing!.hours ?? 0) * 60 +
              (leave?.requiredStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFF2196F3), // Blue
          "icon": Icons.group_add_outlined,
        },
      if (leave?.empStaffing != null)
        {
          "title": "Employee Staffing",
          "value":
              ((leave?.empStaffing!.hours ?? 0) * 60 +
              (leave?.empStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFFE91E63), // Pink
          "icon": Icons.badge_outlined,
        },
    ];
  }
}
