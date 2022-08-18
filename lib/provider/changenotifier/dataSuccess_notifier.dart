import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataChangeNotifier = ChangeNotifierProvider((ref) => DataProvider());

class DataProvider extends ChangeNotifier {
  String response = '';

  void callBack(String data) {
    response = data;
    notifyListeners();
  }
}
