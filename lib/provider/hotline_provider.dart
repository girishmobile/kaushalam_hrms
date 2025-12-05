import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api_config.dart';
import '../api/network_repository.dart';
import '../models/department_model.dart';
import '../models/designation_model.dart';
import '../models/hotline_count_model.dart';
import '../models/hotline_list_model.dart';

class HotlineProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<HotlineCountModel> _hotlineCount = [];

  List<HotlineCountModel> get hotlineCount => _hotlineCount;
  int? _selectedHotlineIndex = 0;

  int? get selectedHotlineIndex => _selectedHotlineIndex;

  void selectHotline(int index) {
    _selectedHotlineIndex = index;

    notifyListeners();
  }
  Future<void> resetHotlineData() async {
    _setLoading(true);

    // Clear all stored data
    _hotlineCount = [];
    _departmentModel = null;
    _departments = [];
    _selectedDepartment = null;
    _designationModel = null;
    _designationList = [];
    _selectDesignation = null;
    _hotlineListModel = null;
    _selectedHotlineIndex = 0;
    _title = "online";

    notifyListeners();
  }
  String? _title = "online";

  String? get title => _title;

  void setHeaderTitle(String title) {
    _title = title;

    notifyListeners();
  }

  Future<void> getLeaveCountData() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.hotlineCountUrl,
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        if (decoded is Map<String, dynamic>) {
          _hotlineCount = decoded.entries
              .map((e) => HotlineCountModel(title: e.key, count: e.value))
              .toList();
        } else {
          _hotlineCount = [];
        }
      } else {}
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  DepartmentModel? _departmentModel;

  DepartmentModel? get departmentModel => _departmentModel;

  Future<void> getAllDepartment() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.departmentUrl,
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _departmentModel = DepartmentModel.fromJson(json.decode(response));
        setDepartments(departmentModel?.data ?? []);
        _setLoading(false);

      } else {
        _setLoading(false);
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  List<Data> _departments = [];
  Data? _selectedDepartment;

  List<Data> get departments => _departments;

  Data? get selectedDepartment => _selectedDepartment;

  /// Load data (from API or local JSON)
  void setDepartments(List<Data> list) {
    _departments = list;
    notifyListeners();
  }

  /// Select a department
  void selectDepartment(Data department) {
    _selectedDepartment = department;
    if (_selectedDepartment != null) {
      getAllHotline(desId: _selectedDepartment?.id ?? 0);
    }
    notifyListeners();
  }

  DesignationModel? _designationModel;

  DesignationModel? get designationModel => _designationModel;

  Future<void> getAllDesignation() async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.getAllDesignationUrl,
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _designationModel = DesignationModel.fromJson(json.decode(response));
        setDesignationData(_designationModel?.data ?? []);
        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  List<DesignationData> _designationList = [];
  DesignationData? _selectDesignation;

  List<DesignationData> get designationList => _designationList;

  DesignationData? get selectDesignation => _selectDesignation;

  /// Load data (from API or local JSON)
  void setDesignationData(List<DesignationData> list) {
    _designationList = list;

    notifyListeners();
  }

  /// Select a department
  void selectDesignationData(DesignationData designationData) {
    _selectDesignation = designationData;
    if (_selectDesignation != null) {
      getAllHotline(desId: _selectDesignation?.id ?? 0);
    }

    notifyListeners();
  }

  HotlineListModel? _hotlineListModel;

  HotlineListModel? get hotlineListModel => _hotlineListModel;

  Future<void> getAllHotline({
    String? search,
    int? depId,
    String? status,
    int? desId,
  }) async {
    final Map<String, dynamic> body = {
      "status": status?.isEmpty == true ? "" : status,
      "start": 1,
      "length": 500,
      "search": search?.isEmpty == true ? "" : search,
      "dep_id": depId ?? "",
      "des_id": desId ?? "",
    };

    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.hotlineUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {

        _hotlineListModel = HotlineListModel.fromJson(json.decode(response));
        _setLoading(false);

      } else {
        _setLoading(false);
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.blue,
    Colors.redAccent,
  ];

  void clearData() {
    _hotlineCount = [];
    _departmentModel = null;
    _departments = [];
    _selectedDepartment = null;
    _designationModel = null;
    _designationList = [];
    _selectDesignation = null;
    _hotlineListModel = null;

    notifyListeners();
  }
}
