import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/api/network_repository.dart';
import 'package:neeknots_admin/models/hotline_list_model.dart';

class ManagerHotlineProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final searchFocus = FocusNode();

  ManagerHotlineProvider() {
    nameController.addListener(() {
      searchByName(nameController.text);
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<HotLineData> _hotlineDataList = [];
  List<HotLineData> get hotlineDataList => _hotlineDataList;

  //Searching and filtering
  List<HotLineData> filteredList = [];

  HotlineListModel? _hotlineListModel;
  HotlineListModel? get hotlineListModel => _hotlineListModel;

  void searchByName(String query) {
    if (query.isEmpty) {
      filteredList = _hotlineDataList;
    } else {
      filteredList = _hotlineDataList
          .where(
            (e) =>
                (e.firstname?.toLowerCase() ?? '').contains(
                  query.toLowerCase(),
                ) ||
                (e.lastname?.toLowerCase() ?? '').contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
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
    _hotlineDataList = [];
    filteredList = [];
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

        _hotlineDataList = (json as List<dynamic>)
            .map((e) => HotLineData.fromJson(e))
            .toList();
        filteredList = _hotlineDataList;
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

  void reset() {
    nameController.clear();
    searchFocus.unfocus();
    _isLoading = false;
    _hotlineDataList = [];
    filteredList = [];
    _hotlineListModel = null;
    notifyListeners();
  }
}
