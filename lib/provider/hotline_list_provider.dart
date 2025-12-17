// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/hotline_count_model.dart';
import 'package:neeknots_admin/models/hotline_list_model.dart';

class HotlineListProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? _selectedTitle;
  String? get selectedTitle => _selectedTitle;

  List<HotlineCountModel> _hotlineCount = [];
  List<HotlineCountModel> get hotlineCount => _hotlineCount;

  List<HotLineData> _hotline_employees = [];
  List<HotLineData> get hotline_employees => _hotline_employees;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// 🔥 ON OPTION TAP
  Future<void> selectHotline(String title) async {
    if (_selectedTitle == title) return;
    _selectedTitle = title;
    notifyListeners();
    final status = mapHotlineStatus(title);
    await getAllHotline(status: status);
  }

  String? mapHotlineStatus(String? title) {
    if (title == null) return null;

    switch (title.toLowerCase()) {
      case 'on_wfh':
        return 'wfh';

      case 'on_break':
        return 'on-break';

      case 'on_leave':
        return 'on-leave';
      case 'online':
      case 'offline':
        return title;
      default:
        return null;
    }
  }

  Future<void> getHotlineCountData() async {
    _hotline_employees = [];
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
          if (_hotlineCount.isNotEmpty) {
            _selectedTitle = _hotlineCount.first.title;
            notifyListeners();
            await getAllHotline(status: _selectedTitle!);
          }
        } else {
          _hotlineCount = [];
        }
      } else {}
      _setLoading(false);
    } catch (e) {
      debugPrint('Error: $e');
      _setLoading(false);
    }
  }

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
    _hotline_employees = [];
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.hotlineUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );
      if (globalStatusCode == 200) {
        final decoded = jsonDecode(response);
        final data = decoded['data'];
        final json = data['data'];
        _hotline_employees = (json as List<dynamic>)
            .map((e) => HotLineData.fromJson(e))
            .toList();

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
}
