import 'package:flutter/material.dart';
import 'package:neeknots_admin/models/user_model.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';

class SettingProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadUserdataFromstorage() async {
    setLoading(true);
    UserModel? user = await SecureStorage.getUser();
    if (user != null) {
      _userModel = user;
    }
    setLoading(false);
  }
}
