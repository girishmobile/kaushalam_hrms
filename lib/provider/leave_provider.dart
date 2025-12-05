import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/all_leave_model.dart';
import 'package:neeknots_admin/models/apply_leave_model.dart';
import 'package:neeknots_admin/models/user_model.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';
import 'package:neeknots_admin/utility/utils.dart';

class LeaveProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  String? _employeeId;
  String? get employeeId => _employeeId;

  bool _applySuccess = false;
  bool get applySuccess => _applySuccess; // getters
  bool _deleteSuccess = false;
  bool get deleteSuccess => _deleteSuccess; // getters

  //for data bindig to apply leave page
  List<LeaveTypes> leaveTypes = [];
  LeaveByEmp? leaveByEmp;

  List<MyLeave> listOfLeave = [];
  String? errorMessage;

  Future<void> loadUserdataFromstorage() async {
    _setLoading(true);
    UserModel? user = await SecureStorage.getUser();
    if (user != null) {
      _employeeId = "${user.id}";
      _setLoading(false);
    }
  }

  void _setApplyLeaveSuccess(bool val) {
    _isLoading = false;
    _applySuccess = val;
    notifyListeners();
  }

  void deleteLeaveSuccess(bool val) {
    _isLoading = false;
    _deleteSuccess = val;
    notifyListeners();
  }

  Future<void> getLeaveTypes({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getLeaveDataUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        // _applyleaveModel = ApplyLeaveModel.fromJson(decoded);
        // ApplyLeaveModel.fromApiJson(json.decode(response));
        if (decoded['leaveByEmp'] != null) {
          leaveByEmp = LeaveByEmp.fromJson(decoded['leaveByEmp']);
        }
        if (decoded["leaveTypes"] != null) {
          leaveTypes = (decoded["leaveTypes"] as List<dynamic>)
              .map((e) => LeaveTypes.fromApiJson(e))
              .toList();
        }

        _setLoading(false);
      } else {
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> applyLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);

    try {
      final response = await callApi(
        url: ApiConfig.applyLeave,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        if (decoded == "created") {
          errorMessage = "Your leave request has been processed successfully.";
          _setApplyLeaveSuccess(true);
        } else if (decoded == "updated") {
          errorMessage = "Your leave request has been updated successfully.";
          _setApplyLeaveSuccess(true);
        } else {
          errorMessage = decoded ?? "Leave request failed. Please try again";
          _setApplyLeaveSuccess(false);
        }
      } else {
        errorMessage =
            "Failed to submit your leave request. Please try again later.";
        _setApplyLeaveSuccess(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setApplyLeaveSuccess(false);
    }
  }

  Future<void> getAllLeaveByEmployee({required String title}) async {
    listOfLeave.clear();
    _setLoading(true);
    final Map<String, dynamic> body = {
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
          "name": "leavetype",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 2,
          "name": "leave_date",
          "searchable": true,
          "orderable": true,
          "search": {"value": title == "All" ? "all" : "", "regex": false},
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
          "search": {"value": title == "All" ? "all" : title, "regex": false},
        },
        {
          "data": 5,
          "name": "status",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
      ],
      "order": [],
      "start": 0,
      "length": 15,
      "search": {"value": title == "All" ? "" : "", "regex": false},
    };
    try {
      final response = await callApi(
        url: ApiConfig.employeeLeavesUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        if (decoded["data"] != null) {
          try {
            listOfLeave = (decoded["data"] as List<dynamic>)
                .map((e) => MyLeave.fromApiJson(e))
                .toList();
          } catch (e) {
            print("error- $e");
          }
        }

        errorMessage = "You have successfully fetched.";
        _setApplyLeaveSuccess(true);
      } else {
        errorMessage =
            "Failed to submit your leave request. Please try again later.";
        _setApplyLeaveSuccess(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setApplyLeaveSuccess(false);
    }
  }

  Future<void> deleteLeave({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      await callApi(
        url: ApiConfig.deleteLeaveUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        deleteLeaveSuccess(true);
      } else {
        deleteLeaveSuccess(false);
      }
    } catch (e) {
      deleteLeaveSuccess(false);
    }
  }

  List<LeaveDropdownItem> getLeaveTypeDropdownItems() {
    final items = <LeaveDropdownItem>[];

    for (final type in leaveTypes) {
      final code = type.leavetype ?? '';
      String balance = "0.00";

      switch (code.toUpperCase()) {
        case 'CL':
          balance = leaveByEmp?.cl ?? "0.00";
          break;
        case 'PL':
          balance = leaveByEmp?.pl ?? "0.00";
          break;
        case 'SL':
          balance = leaveByEmp?.sl ?? "0.00";
          break;
        case 'UPL':
          balance = leaveByEmp?.usedUpl ?? "0.00";
          break;
      }
      // 👇 Skip if balance == 0 or 0.0
      if (code.toUpperCase() != 'UPL' && (double.tryParse(balance) ?? 0) <= 0) {
        continue;
      }
      final label = code.toUpperCase() == 'UPL'
          ? code
          : "$code - $balance Left";
      items.add(
        LeaveDropdownItem(
          code: code,
          label: label,
          type: type, // keep the full object
        ),
      );
    }

    return items;
  }
}

class LeaveDropdownItem {
  final String code;
  final String label;
  final LeaveTypes type; // full leave type object

  LeaveDropdownItem({
    required this.code,
    required this.label,
    required this.type,
  });
}

/**
 * if (!context.mounted) return;
      if (provider.applySuccess) {
        showSnackBar(
          context,
          message: "Login Sccussful",
          bgColor: Colors.green,
        );
        Navigator.pop(context);
      } else {
        showSnackBar(
          context,
          message: provider.errorMessage ?? "Leave request failed",
          bgColor: Colors.redAccent,
        );
      }
 */
