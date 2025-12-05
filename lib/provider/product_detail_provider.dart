import 'package:flutter/material.dart';

class ProductDetailProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void resetProductPage() {
    _currentPage = 0;
    notifyListeners();
  }
}
