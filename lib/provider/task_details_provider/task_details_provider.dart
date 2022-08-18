import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/task_details_model.dart';

import '../../model/task_assign_list.dart';
import '../../model/task_details_manager_model.dart';
import '../../service/apiService.dart';
import '../../state/projectcreationsate.dart';

final taskListNotifier =
    FutureProvider.family<TaskCreationList, String>((ref, id) async {
  return await ref.read(apiProvider).getTaskList(id);
});

final taskListManagerNotifier =
FutureProvider.family<TaskCreationManagerList, String>((ref, id) async {
  return await ref.read(apiProvider).getTaskManagerList(id);
});

final taskAssignUserNotifier =
    FutureProvider.family<List<TaskAssignToUserList>,String>((ref,id) async {
  return await ref.read(apiProvider).taskAssignToUserList(id);
});

final taskCreationNotifierProvider =
    StateNotifierProvider<TaskCreationNotifier, ProjectCreationState>((ref) {
  return TaskCreationNotifier(ref);
});

class TaskCreationNotifier extends StateNotifier<ProjectCreationState> {
  Ref ref;

  TaskCreationNotifier(this.ref)
      : super(ProjectCreationState(false, const AsyncLoading(), ''));

  createTaskProvider(TaskDetailsModel taskDetailsModel) async {
    state = _loading();
    final data = await ref.read(apiProvider).createTask(taskDetailsModel);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  ProjectCreationState _dataState(String entity) {
    return ProjectCreationState(false, AsyncData(entity), '');
  }

  ProjectCreationState _loading() {
    return ProjectCreationState(true, state.projectId, '');
  }

  ProjectCreationState _errorState(int statusCode, String errMsg) {
    return ProjectCreationState(
        false, state.projectId, 'response code $statusCode  msg $errMsg');
  }
}
