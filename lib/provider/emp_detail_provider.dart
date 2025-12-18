import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/profile_model.dart';

class EmpDetailProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileModel? _employeeModel;
  ProfileModel? get employeeModel => _employeeModel;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> getEmployeeProfile({required Map<String, dynamic> body}) async {
    _employeeModel = null;
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getUserDetailsByIdUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        _employeeModel = ProfileModel.fromJson(decoded);
      }
      _setLoading(false);
    } catch (e) {
      _setLoading(true);
    }
  }
}
