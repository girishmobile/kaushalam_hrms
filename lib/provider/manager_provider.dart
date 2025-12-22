// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/models/hotline_count_model.dart';
import 'package:neeknots_admin/models/manager_leave_model.dart';
import 'package:neeknots_admin/utility/utils.dart';

class ManagerProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RecentLeave> recent_leaves = [];
  String? errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess; // getter

  List<MyLeave> listOfLeave = [];

  List<HotlineCountModel> _hotlineCount = [];
  List<HotlineCountModel> get hotlineCount => _hotlineCount;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setApiStatus(bool val) {
    _isLoading = false;
    _isSuccess = val;
    notifyListeners();
  }

  Future<void> getLeaveDataDashboard() async {
    _setLoading(true);
    try {
      var response = await callApi(
        url: ApiConfig.getLeaveDataDashboardUrl,
        method: HttpMethod.get,
      );
      if (globalStatusCode == 200) {
        _setLoading(false);
        final decoded = jsonDecode(response);
        if (decoded["recent_leaves"] != null) {
          recent_leaves = (decoded["recent_leaves"] as List<dynamic>)
              .map((e) => RecentLeave.fromApiJson(e))
              .toList();
        }
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
      debugPrint("error -$e");
    }
  }

  Future<void> getAllLeavesForManager() async {
    _setLoading(true);

    Map<String, dynamic> data = {
      "draw": 1,
      "columns": [
        {
          "data": 0,
          "name": "id",
          "searchable": true,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 1,
          "name": "firstname",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 2,
          "name": "leave_date",
          "searchable": true,
          "orderable": true,
          "search": {"value": "all", "regex": false},
        },
        {
          "data": 3,
          "name": "leave_end_date",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 4,
          "name": "leave_count",
          "searchable": true,
          "orderable": true,
          "search": {"value": "Pending", "regex": false},
        },
        {
          "data": 5,
          "name": "reason",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 6,
          "name": "status",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
      ],
      "order": [],
      "start": 0,
      "length": 100,
      "search": {"value": "", "regex": false},
    };
    try {
      var response = await callApi(
        url: ApiConfig.getAllEmployeeLeaveUrl,
        method: HttpMethod.post,
        body: data,
      );
      if (globalStatusCode == 200) {
        _setLoading(false);
        final decoded = jsonDecode(response);
        if (decoded["data"] != null) {
          final json = decoded["data"];
          try {
            listOfLeave = (json["data"] as List<dynamic>)
                .map((e) => MyLeave.fromApiJson(e))
                .toList();
          } catch (e) {
            debugPrint("error- $e");
          }
        }
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
      debugPrint("error -$e");
    }
  }

  Future<void> approvedLeave(
    BuildContext context, {
    required Map<String, dynamic> body,
  }) async {
    _setLoading(true);
    try {
      await callApi(
        url: ApiConfig.approvedLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        _setApiStatus(true);
        if (!context.mounted) return;
        showSnackBar(
          context,
          message: "Leave approved successfully!",
          bgColor: Colors.green,
        );
        getAllLeavesForManager();
      } else {
        _setApiStatus(false);
        if (!context.mounted) return;
        showSnackBar(
          context,
          message: errorMessage ?? "Unable to approve leave. Please try again.",
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
      _setApiStatus(false);
    }
  }

  Future<void> rejectLeave(
    BuildContext context, {
    required Map<String, dynamic> body,
  }) async {
    _setLoading(true);
    try {
      await callApi(
        url: ApiConfig.rejectLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        _setApiStatus(true);
        getAllLeavesForManager();
        if (!context.mounted) return;
        showSnackBar(
          context,
          message: "Leave rejected successfully",
          bgColor: Colors.green,
        );
      } else {
        // Show error dialog
        _setApiStatus(false);
        if (!context.mounted) return;
        showSnackBar(
          context,
          message: errorMessage ?? "Unable to reject leave. Please try again",
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      _setApiStatus(false);
    }
  }

  Future<void> getHotlineCountData() async {
    _hotlineCount = [];
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.hotlineCountUrl,
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        if (decoded is Map<String, dynamic>) {
          _hotlineCount = decoded.entries
              .map((e) => HotlineCountModel(title: e.key, count: e.value))
              .toList();
        } else {
          _hotlineCount = [];
        }
      } else {}
      _setLoading(false);
    } catch (e) {
      debugPrint('Error: $e');
      _setLoading(false);
    }
  }

  Widget getHotlineIcon(String title) {
    switch (title.toLowerCase()) {
      case 'online':
        return Icon(Icons.circle, color: Colors.green, size: 16);
      case 'offline':
        return Icon(Icons.circle, color: Colors.blueGrey, size: 16);
      case 'on_wfh':
        return Icon(
          Icons.home_work_outlined,
          color: Colors.blueAccent,
          size: 24,
        );
      case 'on_break':
        return Icon(Icons.coffee_outlined, color: Colors.amber, size: 24);
      case 'on_leave':
        return Icon(
          Icons.event_busy_outlined,
          color: Colors.redAccent,
          size: 22,
        );
      case 'total_emp':
        return Icon(
          Icons.people_alt_outlined,
          color: Colors.deepPurple.shade300,
          size: 24,
        );
      default:
        return Icon(Icons.help_outline);
    }
  }

  String getHotlineDisplayTitle(String title) {
    switch (title.toLowerCase()) {
      case 'online':
        return 'Online Employees';
      case 'offline':
        return 'Offline Employees';
      case 'on_wfh':
        return 'WFH Employees';
      case 'on_break':
        return 'On Break';
      case 'on_leave':
        return 'On Leave';
      case 'total_emp':
        return 'Total Employee';
      default:
        return title.replaceAll('_', ' ').toUpperCase();
    }
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;

    recent_leaves.clear();
    listOfLeave.clear();

    errorMessage = null;

    notifyListeners();
  }
}
