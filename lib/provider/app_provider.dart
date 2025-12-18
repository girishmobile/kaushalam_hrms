import 'package:flutter/material.dart';
import 'package:neeknots_admin/models/user_model.dart';
import 'package:neeknots_admin/utility/secure_storage.dart';

class AppProvider extends ChangeNotifier {
  bool _isManager = false;
  bool get isManager => _isManager;
  bool _isEmployee = true;
  bool get isEmployee => _isEmployee;

  int _pageIndex = 2;
  int get pageIndex => _pageIndex;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  //Data binding..
  String _isRole = "employee";
  String get isRole => _isRole;

  String? _employeeId;
  String? get employeeId => _employeeId;

  String? _profileImage;
  String? get profileImage => _profileImage;

  void setIsEmployee(bool value) {
    _isEmployee = value;
    notifyListeners();
  }

  void setIsManagerOrSelf(bool value) {
    _isManager = value;
    notifyListeners();
  }

  void resetApp() {
    _isManager = false;
    _isEmployee = true;
    _pageIndex = 2; // or your login/home index
    _isLoading = false;
    _isRole = "employee";
    _employeeId = null;
    _profileImage = null;
    notifyListeners();
  }

  Future<void> loadAppDataFromStorage() async {
    _isLoading = true;
    notifyListeners();
    UserModel? user = await SecureStorage.getUser();
    if (user != null) {
      final roleStr = (user.role["name"] ?? "").toString().toLowerCase();
      _employeeId = "${user.id}";
   //   debugPrint("user role: $roleStr");
      _profileImage = user.profile;
      if (roleStr == "employee") {
        _isRole = "employee";
      } else {
        _isRole = "manager";
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
