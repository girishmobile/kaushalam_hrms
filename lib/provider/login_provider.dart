import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/user_model.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';

import '../components/components.dart';
import '../core/router/route_name.dart';

class LoginProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final tetCurrentPassword = TextEditingController();
  final tetNewPassword = TextEditingController();
  final tetConfirmPassword = TextEditingController();
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  bool _obscureCurrentPassword = true;

  bool get obscureCurrentPassword => _obscureCurrentPassword;
  bool _obscureConfirmPassword = true;

  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool _obscureNewPassword = true;

  bool get obscureNewPassword => _obscureNewPassword;
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

  void toggleCurrentPassword() {
    _obscureCurrentPassword = !_obscureCurrentPassword;
    notifyListeners();
  }

  void toggleNewPassword() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void resetState() {
    tetConfirmPassword.clear();
    tetNewPassword.clear();
    tetCurrentPassword.clear();
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

  Future<void> updatePassword({
    required Map<String, dynamic> body,
    required BuildContext context,
  }) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.userUpdatePasswordURL,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded != "Not Update") {
          resetState();
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Password updated successfully',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );

            // ✅ Redirect after short delay
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.loginPage,
                (route) => false,
              );
            });
          });
        } else {
          showCommonDialog(
            showCancel: false,
            title: "Error",
            context: context,
            content: "Failed to update password",
          );
        }
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: context,
          content: errorMessage,
        );
      }
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }
}
