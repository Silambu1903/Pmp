import 'package:riverpod/riverpod.dart';

class ProjectAllocationSate {
  bool isLoading;
  AsyncValue<String> allocationId;
  String error;

  ProjectAllocationSate(this.isLoading, this.allocationId, this.error);
}