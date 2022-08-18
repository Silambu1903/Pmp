import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/projectmanagementprocessallocationproject.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/service/apiService.dart';

import '../../model/project_assign_user.dart';
import '../../state/projectallocationsate.dart';

final projectAssigneeUserNotifier =
    FutureProvider.family<TaskAssignUserList, List<String>>((ref, id) async {
  return await ref.read(apiProvider).getProjectAssignUser(id);
});

final projectAssignNotifierProvider =
    StateNotifierProvider<ProjectAllocationNotifier, ProjectAllocationSate>(
        (ref) {
  return ProjectAllocationNotifier(ref);
});

class ProjectAllocationNotifier extends StateNotifier<ProjectAllocationSate> {
  Ref ref;

  ProjectAllocationNotifier(this.ref)
      : super(ProjectAllocationSate(false, const AsyncLoading(), ''));

  allocationProject(
      ProjectManagementProcessProjectAssign processProjectAssign) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).projectAssignee(processProjectAssign);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  taskAssignee(var assignId, var taskId, var hours, var assginnedId) async {
    state = _loading();
    final data = await ref
        .read(apiProvider)
        .taskAssignee(assignId, taskId, hours, assginnedId);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  taskUpdateAssignee(var taskId, var hours) async {
    state = _loading();
    final data = await ref.read(apiProvider).taskUpdateAssignee(taskId, hours);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  allocationProjectByTeam(
      ProjectManagementProcessProjectAssign processProjectAssign) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).projectAssigneeTeam(processProjectAssign);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  assignHours(var id, String hours) async {
    state = _loading();
    final data = await ref.read(apiProvider).projectAssigneeHours(id, hours);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  updateAssignHours(var id, String hours) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).updateProjectAssigneeHours(id, hours);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  ProjectAllocationSate _dataState(String entity) {
    return ProjectAllocationSate(false, AsyncData(entity), '');
  }

  ProjectAllocationSate _loading() {
    return ProjectAllocationSate(true, state.allocationId, '');
  }

  ProjectAllocationSate _errorState(int statusCode, String errMsg) {
    return ProjectAllocationSate(
        false, state.allocationId, 'response code $statusCode  msg $errMsg');
  }
}
