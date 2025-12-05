import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';

class MyKpiProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

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

        // Ensure it's a list
        // if (decoded is List) {
        //   _kpiList = decoded.map((e) => KpiModel.fromJson(e)).toList();
        // } else {
        //   _kpiList = [];
        // }
      } else {
        // showCommonDialog(
        //   showCancel: false,
        //   title: "Error",
        //   context: navigatorKey.currentContext!,
        //   content: errorMessage,
        // );
      }
    } catch (e) {
      _setLoading(false);
      notifyListeners();
    }
    _setLoading(false);
    notifyListeners();
  }
}
