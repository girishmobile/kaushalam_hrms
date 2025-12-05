import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/user_model.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';

class LoginProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess; // getter

  String? errorMessage;

  void _setLoginSuccess(bool val) {
    _isLoading = false;
    _loginSuccess = val;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void resetState() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    String? token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _loginSuccess = true;
    } else {
      _loginSuccess = false;
    }
    notifyListeners();
  }

  Future<void> loginApi({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.loginUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);

        if (decoded['response'] == "success") {
          // Convert JSON → UserModel
          final user = UserModel.fromApiJson(decoded);
          // Save in SecureStorage
          await SecureStorage.saveUser(user);
          _setLoginSuccess(true);
        } else if (decoded['response'] == "error") {
          final msg = decoded["data"];
          errorMessage = msg['message'] ?? "Invalid credentials";

          _setLoginSuccess(false);
        } else {
          errorMessage = "Something went wrong. Try again.";
          _setLoginSuccess(false);
        }
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoginSuccess(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoginSuccess(false);
    }
  }

  Future<void> forgotpassword({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.forgotPasswordUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        if (decoded['response'] == "success") {
          resetState();
          _setLoginSuccess(true);
        } else if (decoded['response'] == "error") {
          errorMessage =
              decoded['message'] ?? "User not found with this email address";
          _setLoginSuccess(false);
        } else {
          errorMessage = "Something went wrong. Try again.";
          _setLoginSuccess(false);
        }
      } else {
        errorMessage = "Something went wrong. Try again.";
        _setLoginSuccess(false);
      }
    } catch (e) {
      errorMessage = "Something went wrong. Try again.";
      _setLoginSuccess(false);
    }
  }
}
