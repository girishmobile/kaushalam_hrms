import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/core/constants/colors.dart';
import 'package:neeknots_admin/models/attendace_record_model.dart';

class AttendanceProvider extends ChangeNotifier /*  */ {
  String _selectedDateRange = 'Today';
  String get selectedDateRange => _selectedDateRange;

  DateTimeRange? _customDateRange;
  DateTimeRange? get customDateRange => _customDateRange;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final dateType = [
    "Today",
    "Yesterday",
    "Last 7 days",
    "Last 30 days",
    "This Month",
    "Last Month",
    "Custom Date",
  ];

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

  void setCustomDateRange(DateTimeRange range) {
    _customDateRange = range;
    notifyListeners();
  }

  Future<void> initializeTodayAttendance() async {
    DateTime now = DateTime.now();
    //  DateTime start = DateTime(now.year, now.month, now.day);
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    DateTime start = DateTime(now.year, now.month, 1);
    setSelectedDateRange("This Month");
    await _fetchAttendance(start, end);
  }

  void handleDateRangeSelection(BuildContext context, String value) async {
    DateTime start;
    DateTime end;

    if (value == "Custom Date") {
      final config = CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),

        selectedDayHighlightColor: btnColor2,
        closeDialogOnCancelTapped: true,
        closeDialogOnOkTapped: true,
        /*selectedDates: _customDateRange != null
            ? [_customDateRange!.start, _customDateRange!.end]
            : [],*/
      );

      final List<DateTime?>? result = await showCalendarDatePicker2Dialog(
        context: context,
        config: config,
        dialogSize: const Size(350, 400),
        borderRadius: BorderRadius.circular(15),
      );

      if (result != null &&
          result.length == 2 &&
          result[0] != null &&
          result[1] != null) {
        DateTime start = result[0]!;
        DateTime end = result[1]!;
        String startDate =
            "${start.toIso8601String().split('T')[0]}T00:00:00+05:30";
        String endDate =
            "${end.toIso8601String().split('T')[0]}T23:59:59+05:30";

        setCustomDateRange(DateTimeRange(start: start, end: end));
        setSelectedDateRange(
          //"${start.toLocal().toString().split(' ')[0]} To ${end.toLocal().toString().split(' ')[0]}",
          "${start.day}-${start.month}-${start.year} To ${end.day}-${end.month}-${end.year}",
        );

        await _fetchAttendance(
          DateTime.parse(startDate),
          DateTime.parse(endDate),
        );
      }
    } else {
      setSelectedDateRange(value);

      DateTime now = DateTime.now();
      end = now;

      switch (value) {
        case "Today":
          start = DateTime(now.year, now.month, now.day);
          end = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case "Yesterday":
          start = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: 1));
          end = DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
          ).subtract(Duration(days: 1));
          break;
        case "Last 7 days":
          start = now.subtract(Duration(days: 6));
          break;
        case "Last 30 days":
          start = now.subtract(Duration(days: 29));
          break;
        case "This Month":
          start = DateTime(now.year, now.month, 1);
          break;
        case "Last Month":
          DateTime firstDayThisMonth = DateTime(now.year, now.month, 1);
          start = DateTime(
            firstDayThisMonth.year,
            firstDayThisMonth.month - 1,
            1,
          );
          end = firstDayThisMonth.subtract(Duration(days: 1));
          break;
        default:
          start = now;
      }

      await _fetchAttendance(start, end);
    }
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
        "length": 100,
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
        "title": "Late",
        "value": (leave?.lateDaysRatio ?? 0).toInt(),
        "desc": '% (${leave?.lateDays} Days)', //
        "color": const Color(0xFFFF9800), // Orange
        "icon": Icons.access_time_outlined,
      },
      {
        "title": "Absent",
        "value": leave?.absentDays ?? 0,
        "desc": '% (${leave?.absentDaysRatio} Days)',
        "color": const Color(0xFFF44336), // Red
        "icon": Icons.remove_circle_outline,
      },

      {
        "title": "Half Days",
        "value": leave?.halfDays ?? 0,
        "desc": '',
        "color": const Color(0xFF9C27B0), // Purple
        "icon": Icons.timelapse_outlined,
      },
      {
        "title": "Total Office",
        "value": leave?.requiredStaffing?.minutes == 0
            ? '${leave?.requiredStaffing?.hours ?? 0} hrs'
            : '${leave?.requiredStaffing?.hours ?? 0} hrs ${leave?.requiredStaffing?.minutes ?? 0} mins ',
        "desc": '',
        "color": const Color(0xFF03A9F4), // Light Blue
        "icon": Icons.pie_chart_outline,
      },
      {
        "title": "Total worked",
        "value": leave?.empStaffing?.minutes == 0
            ? '${leave?.empStaffing?.hours ?? 0} hrs'
            : '${leave?.empStaffing?.hours ?? 0} hrs ${leave?.empStaffing?.minutes ?? 0} mins ',
        "desc": '',
        "color": const Color(0xFF009688), // Teal
        "icon": Icons.trending_up,
      },
      {
        "title": "Productivity Ratio",
        "value": leave?.productivityRatio ?? 0,
        "desc": '%',
        "color": const Color(0xFF673AB7), // Deep Purple
        "icon": Icons.groups_outlined,
      },
      /* if (leave?.requiredStaffing != null)
        {
          "title": "Required Staffing",
          "value":
              ((leave?.requiredStaffing!.hours ?? 0) * 60 +
              (leave?.requiredStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFF2196F3), // Blue
          "icon": Icons.group_add_outlined,
        },*/
      /* if (leave?.empStaffing != null)
        {
          "title": "Employee Staffing",
          "value":
              ((leave?.empStaffing!.hours ?? 0) * 60 +
              (leave?.empStaffing!.minutes ?? 0)),
          "desc": '',
          "color": const Color(0xFFE91E63), // Pink
          "icon": Icons.badge_outlined,
        },*/
    ];
  }

  void reset() {
    _selectedDateRange = 'Today';
    _customDateRange = null;
    _isLoading = false;
    _attendanceRecordModel = null;
    notifyListeners();
  }
}
