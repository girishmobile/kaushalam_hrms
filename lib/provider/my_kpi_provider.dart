import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/my_kpi_model.dart';

class MyKpiProvider extends ChangeNotifier {
  late List<String> years;
  late String selectedYear;

  MyKpiProvider() {
    final currentYear = DateTime.now().year;
    years = List.generate(5, (index) => (currentYear - index).toString());
    selectedYear = currentYear.toString(); // 👈 Default to current year
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> setYear(String year) async {
    selectedYear = year;
    notifyListeners();
    await getKPIList(date: year);
  }

  List<MyKpiModel> _kpiList = [];

  List<MyKpiModel> get kpiList => _kpiList;

  Future<void> getKPIList({required String date}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: '${ApiConfig.kpiListUrl}?year=$date',
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);
        //_kpiList = decoded.map((e) => MyKpiModel.fromJson(e)).toList();
        if (decoded is List) {
          _kpiList = decoded.map((e) => MyKpiModel.fromJson(e)).toList();
          // _kpiList.sort((a, b) => (b.month ?? 0).compareTo(a.month ?? 0));
        } else {
          _kpiList = [];
        }

        _setLoading(false);
        notifyListeners(); // ★ IMPORTANT ★
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _setLoading(false);
    }
  }

  void reset() {
    final currentYear = DateTime.now().year;
    years = List.generate(5, (index) => (currentYear - index).toString());
    selectedYear = currentYear.toString();
    _kpiList = [];
    _isLoading = false;
    notifyListeners();
  }
}
