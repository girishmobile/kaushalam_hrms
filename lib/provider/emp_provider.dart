import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/attendance_model.dart';
import 'package:neeknots_admin/models/birth_holiday_model.dart';
import 'package:neeknots_admin/models/employees_model.dart';
import 'package:neeknots_admin/models/leave_summary.dart';

import '../models/my_work_model.dart';

class EmpProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final searchFocus = FocusNode();

  EmpProvider() {
    nameController.addListener(() {
      if (searchFocus.hasFocus) {
        setSelectedIndex(0); // reset department selection
        filterByDepartment("All"); // filter all employees
      }
      searchByName(nameController.text);
    });
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> updateFCMToken() async {
    _setLoading(true);

    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Error getting FCM token for update: $e');
        fcmToken = null;
      }

      Map<String, dynamic> body = {"fcm_token": fcmToken};
      await callApi(
        url: ApiConfig.updateFCMTokenUrl,
        method: HttpMethod.post,

        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _setLoading(false);
      } else {}
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
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
  List<Department> departments = [];

  List<Employee> _allEmployees = [];
  List<Employee> get allEmployees => _allEmployees;

  //Searching and filtering
  List<Employee> filteredList = [];

  void searchByName(String query) {
    if (query.isEmpty) {
      filteredList = _allEmployees;
    } else {
      filteredList = _allEmployees
          .where(
            (e) =>
                e.firstname.toLowerCase().contains(query.toLowerCase()) ||
                e.lastname.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void filterByDepartment(String? departmentName) {
    if (departmentName == null || departmentName == "All") {
      filteredList = _allEmployees; // Reset
    } else {
      filteredList = _allEmployees
          .where(
            (emp) =>
                emp.departmentName.toLowerCase() ==
                departmentName.toLowerCase(),
          )
          .toList();
    }

    notifyListeners();
  }

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

  Future<void> getDepartment() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getDepartmentURL,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);

        if (decoded['response'] == "success") {
          // Parse API list

          List<Department> apiDepartments = (decoded['data'] as List<dynamic>)
              .map((dept) => Department.fromJson(dept))
              .toList();

          departments = [
            Department(id: 0, name: "All", employees: 0),
            ...apiDepartments,
          ];
        } else {
          errorMessage = "Something went wrong. Try again.";
        }

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

  Future<void> getAllEmployees() async {
    _setLoading(true);
    Map<String, dynamic> body = {
      "draw": 1,
      "columns": [
        {
          "data": 0,
          "name": "",
          "searchable": false,
          "orderable": false,
          "search": {"value": "1", "regex": false},
        },
        {
          "data": 1,
          "name": "id",
          "searchable": true,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 2,
          "name": "employee_id",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 3,
          "name": "firstname",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 4,
          "name": "name",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 5,
          "name": "joining_date",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 6,
          "name": "leaves",
          "searchable": true,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 7,
          "name": "tag",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },

        {
          "data": 8,
          "name": "actions",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
      ],
      "order": [
        {"column": 1, "dir": "asc"},
      ],
      "start": 0,
      "length": 200,
      "search": {"value": "", "regex": false},
    };

    try {
      final response = await callApi(
        url: ApiConfig.getAllEmployeeUrl,
        method: HttpMethod.post,
        headers: null,
        body: body,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        EmployeesModel model = EmployeesModel.fromJson(decoded);
        _allEmployees = model.employees;
        filteredList = _allEmployees;
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

  void reset() {
    // Clear text input and focus
    nameController.clear();
    searchFocus.unfocus();

    // Reset loading state
    _isLoading = false;

    // Reset UI/filter
    _selectedIndex = 0;

    // Clear all user-specific data
    _attendanceModel = null;
    _leaveSummary = null;
    _leaveBalance = null;
    _birthHolidayModel = null;

    holidays.clear();
    birthdays.clear();
    departments.clear();

    _allEmployees.clear();
    filteredList.clear();

    _myWorkModel = null;

    // Notify UI
    notifyListeners();
  }
}
