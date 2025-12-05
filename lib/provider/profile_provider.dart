import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess; // getter

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setLoginSuccess(bool val) {
    _isLoading = false;
    _isSuccess = val;
    notifyListeners();
  }

  Future<void> getUserProfile({required Map<String, dynamic> body}) async {
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
        _profileModel = ProfileModel.fromJson(decoded);
        _setLoginSuccess(true);
      } else {
        _setLoginSuccess(false);
      }
    } catch (e) {
      print("errorr:- $e");
      _setLoginSuccess(false);
    }
  }
}
