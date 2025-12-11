import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/emp_notification_model.dart';

class EmpNotifiProvider extends ChangeNotifier {
  final nameController = TextEditingController();

  // EmpNotifiProvider() {
  //   nameController.addListener(() {
  //     filterByName(nameController.text);
  //   });
  // }
  EmpNotifiProvider() {
    nameController.addListener(() {
      _onSearchChanged(nameController.text);
    });
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<EmpNotificationModel> _notifications = [];
  List<EmpNotificationModel> get notifications => _notifications;
  List<EmpNotificationModel> filteredList = [];

  // --- NEW ---
  String _lastQuery = "";
  Timer? _debounce;

  // Remove HTML tags
  String removeHtmlTags(String html) {
    final reg = RegExp(r"<[^>]*>", caseSensitive: false);
    return html.replaceAll(reg, "");
  }

  // Debounced handler
  void _onSearchChanged(String raw) {
    final text = raw.trim();

    if (text == _lastQuery) return; // no changes → no rebuild

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _lastQuery = text;
      _filter(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    nameController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    List<EmpNotificationModel> newList;
    if (q.isEmpty) {
      newList = List.from(_notifications);
    } else {
      newList = _notifications.where((e) {
        final title = removeHtmlTags(e.title).toLowerCase();
        final details = removeHtmlTags(e.details).toLowerCase();

        return title.contains(q) || details.contains(q);
      }).toList();
    }
    // Avoid notifying if same list
    if (_listsEqual(filteredList, newList)) return;
    filteredList = newList;
    notifyListeners();
  }

  bool _listsEqual(List a, List b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false; // assumes model has proper equality or same instances
      }
    }
    return true;
  }

  // optional: helper to update notifications when you fetch them
  void setNotifications(List<EmpNotificationModel> items) {
    _notifications = items;
    filteredList = List.from(items);
    _lastQuery = '';
    notifyListeners();
  }

  void filterByName(String query) {
    final cleanQuery = query.toLowerCase();
    if (cleanQuery.isEmpty) {
      filteredList = notifications;
    } else {
      filteredList = notifications.where((e) {
        final cleanTitle = removeHtmlTags(e.title).toLowerCase();
        final cleanDetails = removeHtmlTags(e.details).toLowerCase();

        return cleanTitle.contains(cleanQuery) ||
            cleanDetails.contains(cleanQuery);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> getEmployeeNotification() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.employeeNotificationUrl,
        method: HttpMethod.get,
        headers: null,
      );
      if (globalStatusCode == 200) {
        _notifications = (jsonDecode(response) as List)
            .map((e) => EmpNotificationModel.fromJson(e))
            .toList();
        filteredList = _notifications;
        notifyListeners();
        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }
}
