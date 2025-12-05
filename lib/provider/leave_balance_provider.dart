// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/leave_balance_model.dart';

class LeaveBalanceProvider extends ChangeNotifier {
  final nameController = TextEditingController();

  LeaveBalanceProvider() {
    nameController.addListener(() {
      filterByName(nameController.text);
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<EmpLeaveBalance> emp_leave_balance = [];

  List<EmpLeaveBalance> filteredList = [];

  void filterByName(String query) {
    if (query.isEmpty) {
      filteredList = emp_leave_balance;
    } else {
      filteredList = emp_leave_balance
          .where(
            (e) =>
                e.firstname.toLowerCase().contains(query.toLowerCase()) ||
                e.lastname.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> getAllEmployeeLeaveBalance({String? search}) async {
    _setLoading(true);

    Map<String, dynamic> body = {
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
          "name": "cl",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 3,
          "name": "pl",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 4,
          "name": "sl",
          "searchable": false,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 5,
          "name": "balance",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
      ],
      "order": [
        {"column": 1, "dir": "asc"},
      ],
      "start": 0,
      "length": 400,
      "search": {"value": search, "regex": false},
    };
    try {
      final response = await callApi(
        url: ApiConfig.employeeLeaveBalance,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);

        if (decoded['data'] is List && decoded.isNotEmpty) {
          emp_leave_balance = (decoded["data"] as List<dynamic>)
              .map((e) => EmpLeaveBalance.fromApiJson(e))
              .toList();

          filteredList = emp_leave_balance;
          _setLoading(false);
        } else {
          errorMessage = "Something went wrong. Try again.";
          _setLoading(false);
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
}
