import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/attendance_model.dart';
import 'package:neeknots_admin/models/birth_holiday_model.dart';
import 'package:neeknots_admin/models/leave_summary.dart';

import '../models/my_work_model.dart';

class EmpProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  AttendanceModel? _attendanceModel;
  AttendanceModel? get attendanceModel => _attendanceModel;

  LeaveSummary? _leaveSummary;
  LeaveSummary? get leaveSummary => _leaveSummary;

  LeaveBalance? _leaveBalance;
  LeaveBalance? get leaveBalance => _leaveBalance;

  BirthHolidayModel? _birthHolidayModel;
  BirthHolidayModel? get birthholidayModel => _birthHolidayModel;

  List<Holiday> holidays = [];
  List<BirthDay> birthdays = [];

  Future<void> getCurrentAttendance() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.attendanceUrl,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        _attendanceModel = AttendanceModel.fromApiJson(decoded);
        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> getLeaveSummary() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.leaveCountDataUrl,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        _leaveSummary = LeaveSummary.fromApiJson(decoded);

        _setLoading(false);
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoading(false);
    }
  }

  Future<void> getLeaveBalance({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.leaveBalanceUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        if (decoded is List && decoded.isNotEmpty) {
          _leaveBalance = LeaveBalance.fromApiJson(decoded[0]);
        }
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoading(false);
    }
  }

  Future<void> getUpcomingBirthHodliday() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.upcomingLeaveHolidayUrl,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        _birthHolidayModel = BirthHolidayModel.fromApiJson(decoded);
        birthdays = (decoded["birthdays"] as List<dynamic>)
            .map((e) => BirthDay.fromApiJson(e))
            .toList();
        _setLoading(false);
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoading(false);
    }
  }

  Future<void> getAllHolidays() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.allHolidays,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        holidays = (decoded as List<dynamic>)
            .map((e) => Holiday.fromApiJson(e))
            .toList();

        _setLoading(false);
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoading(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoading(false);
    }
  }

  MyWorkModel? _myWorkModel;

  MyWorkModel? get myWorkModel => _myWorkModel;

  Future<void> getMYHours({required int id}) async {
    _setLoading(true);
    try {
      Map<String, dynamic> body = {"id": id};
      final response = await callApi(
        url: ApiConfig.getMyHoursURL,
        method: HttpMethod.post,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _myWorkModel = MyWorkModel.fromJson(json.decode(response));

        _setLoading(false);
      } else {}
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint('=====e=$e');
      _setLoading(false);
    }
  }
  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.blue,
    Colors.redAccent,
  ];

  Future<void> getBirthdays() async {}
}
