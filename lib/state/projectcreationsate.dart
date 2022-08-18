
import 'package:riverpod/riverpod.dart';



class ProjectCreationState {
  bool isLoading;
  AsyncValue<String> projectId;
  String error;

  ProjectCreationState(this.isLoading, this.projectId, this.error);
}