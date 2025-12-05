// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/manager_leave_model.dart';

class ManagerProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RecentLeave> recent_leaves = [];
  String? errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess; // getter

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setApiStatus(bool val) {
    _isLoading = false;
    _isSuccess = val;
    notifyListeners();
  }

  Future<void> getAllLeavesForManager() async {
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
      print("error -$e");
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
        // if (!context.mounted) return;
        // showSnackBar(
        //   context,
        //   message: "Leave approved successfully!",
        //   bgColor: Colors.green,
        // );
        //getAllListingLeave();
      } else {
        _setApiStatus(false);
        // if (!context.mounted) return;
        // showSnackBar(
        //   context,
        //   message: errorMessage ?? "Unable to approve leave. Please try again.",
        //   bgColor: Colors.redAccent,
        // );
      }
    } catch (e) {
      // Print full error with stacktrace for better debugging
      _setApiStatus(false);
    }
  }

  Future<void> rejectLeave({required Map<String, dynamic> body}) async {
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
        // if (!context.mounted) return;
        // showSnackBar(
        //   context,
        //   message: "Leave rejected successfully",
        //   bgColor: Colors.green,
        // );
      } else {
        // Show error dialog
        _setApiStatus(false);
        // if (!context.mounted) return;
        // showSnackBar(
        //   context,
        //   message: errorMessage ?? "Unable to reject leave. Please try again",
        //   bgColor: Colors.redAccent,
        // );
      }
    } catch (e) {
      _setApiStatus(false);
    }
  }
}
