import 'package:riverpod/riverpod.dart';

class RatingTaskSate {
  bool isLoading;
  AsyncValue<String> id;
  String error;

  RatingTaskSate(this.isLoading, this.id, this.error);
}