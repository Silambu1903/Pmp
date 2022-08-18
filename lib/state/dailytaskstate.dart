import 'package:riverpod/riverpod.dart';

class DailyTaskSate {
  bool isLoading;
  AsyncValue<String> id;
  String error;

  DailyTaskSate(this.isLoading, this.id, this.error);
}