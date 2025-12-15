import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/emp_notification_model.dart';

class EmpNotifiProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<EmpNotificationModel> _notifications = [];

  List<EmpNotificationModel> get notifications => _notifications;

  Future<void> getEmployeeNotification() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.employeeNotificationUrl,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        try {
          _notifications = (jsonDecode(response) as List)
              .map((e) => EmpNotificationModel.fromJson(e))
              .toList();
        } catch (e) {
          print("error - $e");
        }

        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }
  Future<void> readAllNotification() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.realAllNotification,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {

        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }
  int get unreadCount {
    return _notifications.where((n) => n.isRead == false).length;
  }
}
