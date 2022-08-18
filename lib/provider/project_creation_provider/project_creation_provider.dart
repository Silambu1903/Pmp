import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/project_management_process_team_creation.dart';
import 'package:pmp/model/project_management_project_creation.dart';
import 'package:pmp/model/projectmanagementprojectmanager.dart';

import '../../helper.dart';
import '../../model/login_model.dart';
import '../../model/projectmanagementdetails.dart';

import '../../model/projectmanagementprocessallocationproject.dart';
import '../../model/projectmanagementprocessratingperformance.dart';
import '../../model/projectmanagmentprojectallassignedproject.dart';
import '../../service/apiService.dart';
import '../../state/projectcreationsate.dart';

final getAllProjectList =
    FutureProvider<List<ProjectManagementProcessProjectCreation>>((ref) async {
  return await ref.read(apiProvider).getProjectList();
});

final getRatingNoitifer = FutureProvider<List<Data>>((ref) async {
  return await ref.read(apiProvider).getRatingDataList();
});

final getRatingNotifierDep =
    FutureProvider.family<List<Data>, String>((ref, id) async {
  return await ref.read(apiProvider).getRatingListDep(id);
});

final getRatingNotifierTeam =
    FutureProvider.family<List<Data>, String>((ref, id) async {
  return await ref.read(apiProvider).getRatingListTeam(id);
});

final getProjectListDepartment =
    FutureProvider<List<ProjectManagementProcessProjectCreationDetails>>(
        (ref) async {
  return await ref.read(apiProvider).getProjectListDepartmentHead();
});

final getProjectFilterListDepartment = FutureProvider.family<
    List<ProjectManagementProcessProjectCreationDetails>,
    List<String>>((ref, data) async {
  return await ref.read(apiProvider).getProjectFilterListDepartmentHead(data);
});

final getProjectFilterIndividualDepartment = FutureProvider.family<
    List<ProjectManagementProcessProjectCreationDetails>,
    String>((ref, data) async {
  return await ref.read(apiProvider).getProjectFilterIndividualDepartmentHead(data);
});


final getProjectCodeList = FutureProvider.family<
    List<ProjectManagementProcessProjectCreation>, String>((ref, id) async {
  return await ref.read(apiProvider).getProjectCodeList(id);
});

final getProjectAssignedManagerList =
    FutureProvider<List<ProjectManagementProcessProjectAssignManager>>((
  ref,
) async {
  return await ref.read(apiProvider).getProjectAssigneeDepartment();
});

final getProjectFilterAssignedManagerList = FutureProvider.family<
    List<ProjectManagementProcessProjectAssignManager>,
    List<String>>((ref, id) async {
  return await ref.read(apiProvider).getProjectAssigneeFilterManager(id);
});

final getProjectIndividualAssignedManagerList = FutureProvider.family<
    List<ProjectManagementProcessProjectAssignManager>,
    String>((ref, id) async {
  return await ref.read(apiProvider).getProjectAssigneeIndividualFilterManager(id);
});

final getProjectAssignedTeamList =
    FutureProvider<List<ProjectManagementProcessProjectAssignTeam>>(
        (ref) async {
  return await ref.read(apiProvider).getAssigneeTeam();
});

final getProjectAssignedTeamFilterList = FutureProvider.family<
    List<ProjectManagementProcessProjectAssignTeam>,
    List<String>>((ref, data) async {
  return await ref.read(apiProvider).getAssigneeFilterTeam(data);
});

final getProjectAssignedIndividualTeamFilterList = FutureProvider.family<
    List<ProjectManagementProcessProjectAssignTeam>,
    String>((ref, data) async {
  return await ref.read(apiProvider).getAssigneeIndTeam(data);
});
final projectCreationNotifierProvider =
    StateNotifierProvider<ProjectCreationNotifier, ProjectCreationState>((ref) {
  return ProjectCreationNotifier(ref);
});

class ProjectCreationNotifier extends StateNotifier<ProjectCreationState> {
  Ref ref;

  ProjectCreationNotifier(this.ref)
      : super(ProjectCreationState(false, const AsyncLoading(), ''));

  getProjectValue(
      ProjectManagementProcessProjectCreation projectCreation) async {
    state = _loading();
    final data = await ref.read(apiProvider).createProject(projectCreation);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  getAllocationTeam(
      ProjectManagementProcessAllocationProject
          processAllocationProject) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).allocateProject(processAllocationProject);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  getUpdateValue(
      ProjectManagementProcessProjectCreation projectCreation) async {
    state = _loading();
    final data = await ref.read(apiProvider).updateProject(projectCreation);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  getProjectStatus(dynamic id, String status) async {
    state = _loading();
    final data = await ref.read(apiProvider).statusProject(id, status);
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

final projectAllocationNotifierProvider =
    StateNotifierProvider<ProjectAllocationNotifier, ProjectCreationState>(
        (ref) {
  return ProjectAllocationNotifier(ref);
});

class ProjectAllocationNotifier extends StateNotifier<ProjectCreationState> {
  Ref ref;

  ProjectAllocationNotifier(this.ref)
      : super(ProjectCreationState(false, const AsyncLoading(), ''));

  getAllocationTeam(
      ProjectManagementProcessAllocationProject
          processAllocationProject) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).allocateProject(processAllocationProject);
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
