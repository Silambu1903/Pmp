import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterModelProvider = ChangeNotifierProvider((ref) => ChangeState());

class ChangeState extends ChangeNotifier {
  int value = 0;

  void press() {
    value = value + 0;
    notifyListeners();
  }
}
