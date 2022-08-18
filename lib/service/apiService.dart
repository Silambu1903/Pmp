import 'dart:collection';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pmp/helper.dart';
import 'package:pmp/model/login_model.dart';
import 'package:pmp/model/project_management_process_department.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/model/projectmanagementprojectmanager.dart';
import 'package:pmp/model/ratingvalue.dart';
import 'package:pmp/provider/excepationn_handle/expextion_handle_provider.dart';
import 'package:pmp/service/gqlQuery.dart';

import '../helper/applicationhelper.dart';
import '../model/cumative_performance_model.dart';
import '../model/dpi_rating_list_model.dart';
import '../model/individual_report_model.dart';
import '../model/overall_rating_model.dart';
import '../model/project_assign_user.dart';
import '../model/project_management_process_team_creation.dart';
import '../model/project_management_project_creation.dart';
import '../model/projectcommentmodel.dart';
import '../model/projectmanagementdailyreport.dart';
import '../model/projectmanagementdetails.dart';

import '../model/projectmanagementprocessallocationproject.dart';

import '../model/projectmanagementprocessratingperformance.dart';
import '../model/projectmanagementprocessteamcreation.dart';
import '../model/projectmanagmentprojectallassignedproject.dart';
import '../model/projectreportlist.dart';
import '../model/qpi_project_calculation_project_by_id.dart';
import '../model/ratingModel.dart';

import '../model/task_assign_list.dart';
import '../model/task_details_manager_model.dart';
import '../model/task_details_model.dart';
import '../provider/created_user_provider/created_user_list_provider.dart';
import '../provider/excepationn_handle/socket_expection.dart';
import '../provider/project_allocation_provider/project_report_team_lead.dart';
import '../provider/providerLogin.dart';

Provider<ApiService> apiProvider =
    Provider<ApiService>((ref) => ApiService(ref));

class ApiService {
  final String productionServerURL = 'http://183.82.35.93:8080/v1/graphql';
  final String testServerURL = 'http://192.168.1.82:8080/v1/graphql';
  final Ref ref;

  ApiService(this.ref);

  _getGLClient() {
    HttpLink _httpLink = HttpLink(productionServerURL, defaultHeaders: {
      Helper.secretKey: Helper.secretValue,
    });
    Link _link = _httpLink;
    return GraphQLClient(link: _link, cache: GraphQLCache());
  }

  getQueryResult(String query, {QueryOptions? queryOptions}) async {
    try {
      QueryOptions options = queryOptions ?? QueryOptions(document: gql(query));
      GraphQLClient client = _getGLClient();
      QueryResult result =
          await client.query(options).timeout(const Duration(seconds: 10));
      if (result.hasException) {
        final data = result.exception!.linkException!.originalException.message!
            .toString();
        if (data == 'Connection failed') {
          ref.refresh(socketHandleStateNotifierProvider);
          ref
              .read(socketHandleStateNotifierProvider.notifier)
              .dataHandler('Connection failed');
        }
        throw result.exception.toString();
      }
      return result;
    } catch (e) {
      print(e);
    }
  }

  _getMutationResult(String query, {MutationOptions? mutationOptions}) async {
    try {
      MutationOptions options =
          mutationOptions ?? MutationOptions(document: gql(query));
      GraphQLClient client = _getGLClient();
      QueryResult result =
          await client.mutate(options).timeout(const Duration(seconds: 10));
      if (result.hasException) {
        throw result.exception.toString();
      }
      return result;
    } catch (e) {
      print(e);
    }
  }

  getUser({String? employeeCode, String? password}) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(getLoginDetails),
        variables: {'_eq': employeeCode, '_eq1': password},
      );
      final data = await getQueryResult(getLoginDetails, queryOptions: options);
      List<dynamic> list = [];
      list = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistration> loginModel = list
          .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
          .toList();
      return loginModel;
    } catch (e) {
      print(e);
    }
  }

  getUserWithoutPassword({String? employeeCode}) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(getLoginDetailsWithoutPassword),
        variables: {'_eq': employeeCode},
      );
      final data = await getQueryResult(getLoginDetailsWithoutPassword,
          queryOptions: options);
      List<dynamic> list = [];
      list = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistration> loginModel = list
          .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
          .toList();
      return loginModel;
    } catch (e) {
      print(e);
    }
  }

  taskAssignToUserList(var projectId) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(taskListUserQuery),
        variables: {
          'user_id': Helper.sharedCreatedId,
          'project_id': projectId,
        },
      );
      final data =
          await getQueryResult(taskListUserQuery, queryOptions: options);
      List<dynamic> list = [];
      list = data.data['Project_Management_Process_task_assign'];
      List<TaskAssignToUserList> taskList =
          list.map((e) => TaskAssignToUserList.fromJson(e)).toList();
      return taskList;
    } catch (e) {
      print(e);
    }
  }

  qpiCalculation(var projectId) async {
    try {
      QueryOptions options = QueryOptions(
        document: gql(qpiProjectCalculation),
        variables: {
          'projectId': projectId,
        },
      );
      final data =
          await getQueryResult(qpiProjectCalculation, queryOptions: options);
      List<dynamic> list = [];
      list = data.data['Project_Management_Process_project_creation'];
      List<QPIProjectCalculationProjectById> taskList = list
          .map((e) => QPIProjectCalculationProjectById.fromJson(e))
          .toList();
      return taskList;
    } catch (e) {
      print(e);
    }
  }

  createUser(ProjectManagementProcessUserRegistration loginModel) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(insertUser),
        variables: {
          'user_name': loginModel.userName,
          'password': loginModel.password,
          'email': loginModel.email,
          'employe_code': loginModel.employeCode,
          'mobile_no': loginModel.mobileNo,
          'type': loginModel.type,
          'is_active': loginModel.isActive,
          'created_id': loginModel.createdId,
          'department_id': loginModel.departmentId,
          'avatar': loginModel.avatar,
          'team_id': loginModel.teamId
        },
      );
      data = await _getMutationResult(insertUser, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_user_registration']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  insertDpi(var userId, var taskId, var rating, var teamId, var depId,var createdDate) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(insertDpiQuery),
        variables: {
          'user_id': userId,
          'task_id': taskId,
          'rating': rating,
          'ratedby_id': Helper.sharedCreatedId,
          'team_id': teamId,
          'department_id': depId,
          'createdDate': createdDate,
        },
      );
      data = await _getMutationResult(insertDpiQuery, mutationOptions: options);
      return data.data![
              'insert_Project_Management_Process_daily_performance_index']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  insertSpi(var userId, var rating, var teamId, var depId,var createdDate) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(insertSpiQuery),
        variables: {
          'user_id': userId,
          'rating': rating,
          'ratedby_id': Helper.sharedCreatedId,
          'team_id': teamId,
          'department_id': depId,
          'createdDate': createdDate,
        },
      );
      data = await _getMutationResult(insertSpiQuery, mutationOptions: options);
      return data.data![
              'insert_Project_Management_Process_supervisors_performance_index']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  insertQpi(
      var userId, var projectId, var rating, var teamId, var depId) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(insertQpiQuery),
        variables: {
          'user_id': userId,
          'project_id': projectId,
          'rating': rating,
          'team_id': teamId,
          'ratedby_id': Helper.sharedCreatedId,
          'department_id': depId,
        },
      );
      data = await _getMutationResult(insertQpiQuery, mutationOptions: options);
      return data.data![
              'insert_Project_Management_Process_quality_performance_index']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  insertPri(
      var userId, var projectId, var rating, var teamId, var depId) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(insertPriQuery),
        variables: {
          'user_id': userId,
          'project_id': projectId,
          'rating': rating,
          'team_id': teamId,
          'ratedby_id': Helper.sharedCreatedId,
          'department_id': depId,
        },
      );
      data = await _getMutationResult(insertPriQuery, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_productivity_index']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  createTask(TaskDetailsModel taskDetailsModel) async {
    var data;
    try {
      MutationOptions options = MutationOptions(
        document: gql(addProjectTaskQuery),
        variables: {
          'created_id': taskDetailsModel.createdId,
          'planned_hrs': taskDetailsModel.plannedHrs,
          'description': taskDetailsModel.taskDescription,
          'task_name': taskDetailsModel.taskName,
          'team_id': taskDetailsModel.teamId,
          'project_id': taskDetailsModel.projectId,
        },
      );
      data = await _getMutationResult(addProjectTaskQuery,
          mutationOptions: options);
      return data.data!['insert_Project_Management_Process_task_creation']
          ['returning'][0]['id'];
    } catch (e) {
      return data;
    }
  }

  createProject(
      ProjectManagementProcessProjectCreation processProjectCreation) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(createProjectQuery),
          variables: {
            'project_name': processProjectCreation.projectName,
            'description': processProjectCreation.description,
            'project_code': processProjectCreation.projectCode,
            'planned_hrs': processProjectCreation.plannedHrs,
            'delivery_date': processProjectCreation.deliveryDate,
            'create_date': processProjectCreation.createDate,
            'update_date': processProjectCreation.updateDate,
            'status': 'Open',
            'projectWeightage': processProjectCreation.projectWeightage,
            'projectValue': processProjectCreation.projectValue,
            'description': processProjectCreation.description,
            'deparment_id': processProjectCreation.departmentId,
            'is_active': processProjectCreation.isActive,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(createProjectQuery,
          mutationOptions: options);

      return data.data!['insert_Project_Management_Process_project_creation']
              ['returning'][0]['id'] +
          '&' +
          data.data!['insert_Project_Management_Process_project_creation']
              ['returning'][0]['planned_hrs'];
    } catch (e) {
      return e.toString();
    }
  }

  /* insertConferenceBookingProject(
      ProjectManagementProcessProjectCreation processProjectCreation) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(createProjectQuery),
          variables: {
            'project_name': processProjectCreation.projectName,
            'description': processProjectCreation.description,
            'project_code': processProjectCreation.projectCode,
            'planned_hrs': processProjectCreation.plannedHrs,
            'delivery_date': processProjectCreation.deliveryDate,
            'create_date': processProjectCreation.createDate,
            'update_date': processProjectCreation.updateDate,
            'status': 'Open',
            'projectWeightage': processProjectCreation.projectWeightage,
            'projectValue': processProjectCreation.projectValue,
            'description': processProjectCreation.description,
            'deparment_id': processProjectCreation.departmentId,
            'is_active': processProjectCreation.isActive,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(createProjectQuery,
          mutationOptions: options);

      return data.data!['insert_Project_Management_Process_project_creation']
      ['returning'][0]['id'] +
          '&' +
          data.data!['insert_Project_Management_Process_project_creation']
          ['returning'][0]['planned_hrs'];
    } catch (e) {
      return e.toString();
    }
  }*/

  updateProject(
      ProjectManagementProcessProjectCreation processProjectCreation) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(updateProjectQuery),
          variables: {
            '_eq': processProjectCreation.id,
            'project_name': processProjectCreation.projectName,
            'description': processProjectCreation.description,
            'project_code': processProjectCreation.projectCode,
            'planned_hrs': processProjectCreation.plannedHrs,
            'delivery_date': processProjectCreation.deliveryDate,
            'create_date': processProjectCreation.createDate,
            'update_date': processProjectCreation.updateDate,
            'description': processProjectCreation.description,
            'deparment_id': processProjectCreation.departmentId,
            'is_active': processProjectCreation.isActive,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(updateProjectQuery,
          mutationOptions: options);
      return data.data!['update_Project_Management_Process_project_creation']
              ['returning'][0]['id'] +
          '&' +
          data.data!['update_Project_Management_Process_project_creation']
              ['returning'][0]['planned_hrs'];
    } catch (e) {
      return e.toString();
    }
  }

  statusProject(dynamic id, String status) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(updateProjectStatusQuery),
          variables: {
            '_eq': id,
            'status': status,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(updateProjectStatusQuery,
          mutationOptions: options);
      return data.data!['update_Project_Management_Process_project_creation']
              ['returning'][0]['id'] +
          '&' +
          data.data!['update_Project_Management_Process_project_creation']
              ['returning'][0]['planned_hrs'];
    } catch (e) {
      return e.toString();
    }
  }

  dailyTaskUpdated(ProjectManagementProcessDailyReport processDailyReport,
      String assignId) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(insertDailyTask),
          variables: {
            'project_id': processDailyReport.projectId,
            'user_id': processDailyReport.userId,
            'department_id': processDailyReport.departmentId,
            'spent_hrs': processDailyReport.spentHrs,
            'team_id': processDailyReport.teamId,
            'remarks': processDailyReport.remarks,
            'task_details': processDailyReport.taskDetails,
            'task_assign_id': processDailyReport.taskAssignId,
            'project_assgin_id': assignId,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data =
          await _getMutationResult(insertDailyTask, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_daily_report']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  insertComment(var projectId, var userId, String comment) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(insertCommentQuery),
          variables: {
            'project_id': projectId,
            'user_id': userId,
            'comment': comment,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(insertCommentQuery,
          mutationOptions: options);
      return data.data!['insert_Project_Management_Process_project_comments']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  getAssigneeTeam() async {
    List<dynamic> projectData;
    var createdId = Helper.sharedCreatedId;
    var teamId = Helper.sharedteamId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneeTeamQuery),
      variables: {
        '_eq1': createdId,
        '_eq2': teamId,
      },
    );
    final data =
        await getQueryResult(getAssigneeTeamQuery, queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignTeam> projectAssign = projectData
        .map((e) => ProjectManagementProcessProjectAssignTeam.fromJson(e))
        .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getAssigneeFilterTeam(List<String> value) async {
    List<dynamic> projectData;
    var createdId = Helper.sharedCreatedId;
    var teamId = Helper.sharedteamId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneeFilterTeamQuery),
      variables: {
        '_eq1': createdId,
        '_eq2': teamId,
        '_date': value[0],
        '_status': value[1],
      },
    );
    final data =
        await getQueryResult(getAssigneeFilterTeamQuery, queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignTeam> projectAssign = projectData
        .map((e) => ProjectManagementProcessProjectAssignTeam.fromJson(e))
        .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getAssigneeIndTeam(String value) async {
    List<dynamic> projectData;
    var createdId = Helper.sharedCreatedId;
    var teamId = Helper.sharedteamId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneIndividualTeamQuery),
      variables: {
        'project_id': value,
        '_eq1': createdId,
        '_eq2':teamId,
      },
    );
    final data =
    await getQueryResult(getAssigneIndividualTeamQuery, queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignTeam> projectAssign = projectData
        .map((e) => ProjectManagementProcessProjectAssignTeam.fromJson(e))
        .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getProjectAssigneeDepartment() async {
    List<dynamic> projectData;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneeDepartment),
      variables: {
        '_eq': id,
      },
    );
    final data =
        await getQueryResult(getAssigneeDepartment, queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignManager> projectAssign =
        projectData
            .map(
                (e) => ProjectManagementProcessProjectAssignManager.fromJson(e))
            .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getProjectAssigneeFilterManager(List<String> value) async {
    List<dynamic> projectData;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneeFilterManagerQuery),
      variables: {
        '_eq': id,
        '_date': value[0],
        '_status': value[1],
      },
    );
    final data = await getQueryResult(getAssigneeFilterManagerQuery,
        queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignManager> projectAssign =
        projectData
            .map(
                (e) => ProjectManagementProcessProjectAssignManager.fromJson(e))
            .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getProjectAssigneeIndividualFilterManager(var value) async {
    List<dynamic> projectData;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getAssigneeIndividualManagerQuery),
      variables: {
        '_eq': id,
        'project_id': value,

      },
    );
    final data = await getQueryResult(getAssigneeIndividualManagerQuery,
        queryOptions: options);
    projectData = data.data['Project_Management_Process_project_assign'];
    List<ProjectManagementProcessProjectAssignManager> projectAssign =
    projectData
        .map(
            (e) => ProjectManagementProcessProjectAssignManager.fromJson(e))
        .toList();
    try {
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getDailyReportDetails(id) async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getDailyTask),
      variables: {'_eq1': id, '_eq2': Helper.sharedCreatedId},
    );
    try {
      final data = await getQueryResult(getDailyTask, queryOptions: options);
      projectData = data.data['Project_Management_Process_daily_report'];
      List<ProjectManagementProcessDailyReport> projectAssign = projectData
          .map((e) => ProjectManagementProcessDailyReport.fromJson(e))
          .toList();
      print(projectData.length);
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getDpiRatingList(List<String> id) async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(dpiRatingQuery),
      variables: {'_eq1': id[0], '_eq2': id[1]},
    );
    try {
      final data = await getQueryResult(dpiRatingQuery, queryOptions: options);
      projectData = data.data['Project_Management_Process_daily_report'];
      List<DpiRatingDailyReport> projectAssign =
          projectData.map((e) => DpiRatingDailyReport.fromJson(e)).toList();
      return projectAssign;
    } catch (e) {
      print(e);
    }
  }

  getProjectReportSuperAdminData() async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getProjectReportSuperAdmin),
    );
    try {
      final data = await getQueryResult(getProjectReportSuperAdmin,
          queryOptions: options);
      projectData = data.data['Project_Management_Process_project_creation'];
      List<ProjectReportList> projectList =
          projectData.map((e) => ProjectReportList.fromJson(e)).toList();

      return projectList;
    } catch (e) {
      rethrow;
    }
  }

  getProjectReportDepartmentHeadData(List<String> data) async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getProjectReportDepartmentHead),
      variables: {
        '_eq': Helper.shareddepId,
        '_date': data[0],
        '_status': data[1],
      },
    );
    try {
      final data = await getQueryResult(getProjectReportDepartmentHead,
          queryOptions: options);
      projectData = data.data['Project_Management_Process_project_creation'];
      List<ProjectReportList> projectList =
          projectData.map((e) => ProjectReportList.fromJson(e)).toList();

      return projectList;
    } catch (e) {
      rethrow;
    }
  }

  getProjectReportDepartmentTeamLead(List<String> value) async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getProjectReportTeamLead),
      variables: {
        '_eq': Helper.sharedteamId,
        '_date': value[0],
        '_status': value[1],
      },
    );
    try {
      final data =
          await getQueryResult(getProjectReportTeamLead, queryOptions: options);
      projectData = data.data['Project_Management_Process_allocation_project'];
      List<ProjectReportTeamLead> projectList =
          projectData.map((e) => ProjectReportTeamLead.fromJson(e)).toList();

      return projectList;
    } catch (e) {
      print(e);
    }
  }

  getDailyReportManagerDetails(id) async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getDailyTask),
      variables: {'_eq1': id, '_eq2': Helper.sharedCreatedId},
    );
    try {
      final data = await getQueryResult(getDailyTask, queryOptions: options);
      projectData = data.data['Project_Management_Process_daily_report'];
      List<ProjectManagementProcessDailyReport> projectAssign = projectData
          .map((e) => ProjectManagementProcessDailyReport.fromJson(e))
          .toList();
      print(projectData.length);
      return projectAssign;
    } catch (e) {
      rethrow;
    }
  }

  getRatingDataList() async {
    dynamic item1;
    List<dynamic> item2;
    List<Data> list = [];
    QueryOptions options = QueryOptions(
      document: gql(getRatingData),
    );
    final data = await getQueryResult(getRatingData, queryOptions: options);
    try {
      item1 = data.data['item1'];
      item2 = data.data['item2'];
      Item1 rating1 = Item1.fromJson(item1);
      List<ProjectManagementProcessRatingPerformance> ratingList = item2
          .map((e) => ProjectManagementProcessRatingPerformance.fromJson(e))
          .toList();
      list.add(Data(item1: rating1, item2: ratingList));
      return list;
    } catch (e) {
      return e;
    }
  }

  getOverAllRatingList() async {
    List<dynamic> item1;
    QueryOptions options = QueryOptions(
      document: gql(getOverAllRatingQuery),
    );
    final data =
        await getQueryResult(getOverAllRatingQuery, queryOptions: options);
    try {
      item1 = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistrationOverAll> userRatingList =
          item1
              .map((e) =>
                  ProjectManagementProcessUserRegistrationOverAll.fromJson(e))
              .toList();
      final dpiTotal = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final dpiCount = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['count'];
      final spiTotal = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final spiCount = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['count'];
      final qpiTotal = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['sum']['rating_value'];
      final qpiCount = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['count'];
      final priTotal =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['sum']['rating'];
      final priCount =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['count'];

      return OverAllRatingModel(
          projectManagementProcessUserRegistration: userRatingList,
          dpiTotal: dpiTotal,
          dpiCount: dpiCount,
          spiTotal: spiTotal,
          spiCount: spiCount,
          qpiTotal: qpiTotal,
          qpiCount: qpiCount,
          priTotal: priTotal,
          priCount: priCount);
    } catch (e) {
      return e;
    }
  }

  getOverAllRatingListDepartmentWise(var depId) async {
    List<dynamic> item1;
    QueryOptions options = QueryOptions(
      document: gql(getOverAllRatingDepartmentWiseQuery),
      variables: {
        '_eq': depId,
      },
    );
    final data = await getQueryResult(getOverAllRatingDepartmentWiseQuery,
        queryOptions: options);
    try {
      item1 = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistrationOverAll> userRatingList =
          item1
              .map((e) =>
                  ProjectManagementProcessUserRegistrationOverAll.fromJson(e))
              .toList();
      final dpiTotal = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final dpiCount = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['count'];
      final spiTotal = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final spiCount = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['count'];
      final qpiTotal = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['sum']['rating_value'];
      final qpiCount = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['count'];
      final priTotal =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['sum']['rating'];
      final priCount =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['count'];

      return OverAllRatingModel(
          projectManagementProcessUserRegistration: userRatingList,
          dpiTotal: dpiTotal,
          dpiCount: dpiCount,
          spiTotal: spiTotal,
          spiCount: spiCount,
          qpiTotal: qpiTotal,
          qpiCount: qpiCount,
          priTotal: priTotal,
          priCount: priCount);
    } catch (e) {
      return e;
    }
  }

  getOverAllRatingListTeamWise(var teamId) async {
    List<dynamic> item1;
    QueryOptions options = QueryOptions(
      document: gql(getOverAllRatingTeamWiseQuery),
      variables: {
        '_eq': teamId,
      },
    );
    final data = await getQueryResult(getOverAllRatingTeamWiseQuery,
        queryOptions: options);
    try {
      item1 = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistrationOverAll> userRatingList =
          item1
              .map((e) =>
                  ProjectManagementProcessUserRegistrationOverAll.fromJson(e))
              .toList();
      final dpiTotal = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final dpiCount = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['count'];
      final spiTotal = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final spiCount = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['count'];
      final qpiTotal = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['sum']['rating_value'];
      final qpiCount = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['count'];
      final priTotal =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['sum']['rating'];
      final priCount =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['count'];

      return OverAllRatingModel(
          projectManagementProcessUserRegistration: userRatingList,
          dpiTotal: dpiTotal,
          dpiCount: dpiCount,
          spiTotal: spiTotal,
          spiCount: spiCount,
          qpiTotal: qpiTotal,
          qpiCount: qpiCount,
          priTotal: priTotal,
          priCount: priCount);
    } catch (e) {
      return e;
    }
  }

  getTeamWiseReport() async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getTeamReport),
      variables: {
        '_eq': Helper.shareddepId,
      },
    );
    try {
      final data = await getQueryResult(getTeamReport, queryOptions: options);
      projectData = data.data['Project_Management_Process_team_creation'];
      List<ProjectManagementProcessTeamCreationReport> projectAssign =
          projectData
              .map(
                  (e) => ProjectManagementProcessTeamCreationReport.fromJson(e))
              .toList();
      return projectAssign;
    } catch (e) {
      return e;
    }
  }

  getTeamLeadReport() async {
    List<dynamic> projectData;
    QueryOptions options = QueryOptions(
      document: gql(getTeamLeadReportQuery),
      variables: {
        '_eq': Helper.sharedteamId,
      },
    );
    try {
      final data =
          await getQueryResult(getTeamLeadReportQuery, queryOptions: options);
      projectData = data.data['Project_Management_Process_team_creation'];
      List<ProjectManagementProcessTeamCreationReport> projectAssign =
          projectData
              .map(
                  (e) => ProjectManagementProcessTeamCreationReport.fromJson(e))
              .toList();

      return projectAssign;
    } catch (e) {
      return e;
    }
  }

  getRatingListDep(var id) async {
    dynamic item1;
    List<dynamic> item2;
    List<Data> list = [];
    QueryOptions options = QueryOptions(
      document: gql(getRatingDataByDep),
      variables: {
        '_eq': id,
      },
    );
    final data =
        await getQueryResult(getRatingDataByDep, queryOptions: options);
    try {
      item1 = data.data['item1'];
      item2 = data.data['item2'];
      if (item2.isNotEmpty) {
        Item1 rating1 = Item1.fromJson(item1);
        List<ProjectManagementProcessRatingPerformance> ratingList = item2
            .map((e) => ProjectManagementProcessRatingPerformance.fromJson(e))
            .toList();
        list.add(Data(item1: rating1, item2: ratingList));
      }
      return list;
    } catch (e) {
      return e;
    }
  }

  getRatingListTeam(var id) async {
    dynamic item1;
    List<dynamic> item2;
    List<Data> list = [];
    QueryOptions options = QueryOptions(
      document: gql(getRatingDataByTeam),
      variables: {
        '_eq': id,
      },
    );
    final data =
        await getQueryResult(getRatingDataByTeam, queryOptions: options);
    try {
      item1 = data.data['item1'];
      item2 = data.data['item2'];
      if (item2.isNotEmpty) {
        Item1 rating1 = Item1.fromJson(item1);
        List<ProjectManagementProcessRatingPerformance> ratingList = item2
            .map((e) => ProjectManagementProcessRatingPerformance.fromJson(e))
            .toList();
        list.add(Data(item1: rating1, item2: ratingList));
      }
      return list;
    } catch (e) {
      return e;
    }
  }

  projectAssignee(
      ProjectManagementProcessProjectAssign processProjectAssign) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(projectAssign),
          variables: {
            'project_id': processProjectAssign.projectId,
            'assigned_id': processProjectAssign.assignedId,
            'user_id': processProjectAssign.userId,
            'is_active': processProjectAssign.isActive,
            'assigned_hrs': processProjectAssign.assignedHourBool,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data =
          await _getMutationResult(projectAssign, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_project_assign']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  taskAssignee(var projectId, var taskId, var hrs, var assignedId) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(taskAssignQuery),
          variables: {
            'project_assgin_id': projectId,
            'task_id': taskId,
            'task_assign_hrs': hrs,
            'assigned_by_id': Helper.sharedCreatedId,
            'assignee_to_id': assignedId,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data =
          await _getMutationResult(taskAssignQuery, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_task_assign']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  taskUpdateAssignee(var taskId, var hrs) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(taskAssignUpdateQuery),
          variables: {
            'taskId': taskId,
            'hours': hrs,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(taskAssignUpdateQuery,
          mutationOptions: options);
      return data.data!['insert_Project_Management_Process_task_assign']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  projectAssigneeTeam(
      ProjectManagementProcessProjectAssign processProjectAssign) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(projectAssignByTeamLead),
          variables: {
            'project_id': processProjectAssign.projectId,
            'assigned_id': processProjectAssign.assignedId,
            'user_id': processProjectAssign.userId,
            'is_active': processProjectAssign.isActive,
            'assigned_hrs': processProjectAssign.assignedHourBool,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(projectAssignByTeamLead,
          mutationOptions: options);
      return data.data!['insert_Project_Management_Process_project_creation']
              ['returning'][0]['id'] +
          '&' +
          data.data!['insert_Project_Management_Process_project_creation']
              ['returning'][0]['planned_hrs'];
    } catch (e) {
      return e.toString();
    }
  }

  projectAssigneeHours(id, hours) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(projectAssignHours),
          variables: {
            'id': id,
            'assign_hr': hours,
            'assigned_hrs': true,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final data = await _getMutationResult(projectAssignHours,
          mutationOptions: options);
      return data.data!['insert_Project_Management_Process_assign_hrs']
          ['returning'][0]['id'];
    } catch (e) {
      return e.toString();
    }
  }

  updateProjectAssigneeHours(var id, String hours) async {
    try {
      MutationOptions options = MutationOptions(
        document: gql(updateAssignHrs),
        variables: {
          '_eq': id,
          'assign_hrs': hours,
        },
      );
      final data =
          await _getMutationResult(updateAssignHrs, mutationOptions: options);
      return data.data!['update_Project_Management_Process_assign_hrs']
          ['returning'][0]['id'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  allocateProject(
      ProjectManagementProcessAllocationProject
          processAllocationProject) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(projectAllocation),
          variables: {
            'team_id': processAllocationProject.teamId,
            'project_id': processAllocationProject.projectId,
            'planned_hrs': processAllocationProject.plannedHrs,
            'is_active': processAllocationProject.isActive,
            'created_id': processAllocationProject.createdId,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final QueryResult data =
          await _getMutationResult(projectAllocation, mutationOptions: options);
      return data.data!['insert_Project_Management_Process_allocation_project']
          ['returning'][0]['id'];
    } catch (e) {
      print(e);
    }
  }

  allocateProjectUpdate(
      ProjectManagementProcessAllocationProject
          processAllocationProject) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(projectAllocationUpdate),
          variables: {
            '_eq': processAllocationProject.id,
            'team_id': processAllocationProject.teamId,
            'project_id': processAllocationProject.projectId,
            'planned_hrs': processAllocationProject.plannedHrs,
            'is_active': processAllocationProject.isActive,
            'created_id': processAllocationProject.createdId,
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {}
          });
      final QueryResult data = await _getMutationResult(projectAllocationUpdate,
          mutationOptions: options);
      return data;
    } catch (e) {
      print(e);
    }
  }

  updateUser(ProjectManagementProcessUserRegistration loginModel) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(updateUserQuery),
          variables: {
            'user_name': loginModel.userName,
            'password': loginModel.password,
            'email': loginModel.email,
            'employe_code': loginModel.employeCode,
            'mobile_no': loginModel.mobileNo,
            'is_active': loginModel.isActive
          },
          onError: (error) {},
          onCompleted: (data) {
            if (data != null) {
              ref.read(loginNotifier.notifier).fetchUser(
                  Helper.sharedEmployeeCode!, Helper.sharedpassword!);
              ref.refresh(userListStateProvider);
            }
          });
      final QueryResult data =
          await _getMutationResult(updateUserQuery, mutationOptions: options);

      return data.data!['update_Project_Management_Process_user_registration']
          ['returning'][0]['id'];
    } catch (e) {
      print(e);
    }
  }

  getDepartments() async {
    List<ProjectManagementProcessDepartmentCreation> departments = [];
    List<dynamic> departmentsData;
    final data = await getQueryResult(getDepartmentDetails);
    if (data != null) {
      ref
          .read(exceptionHandleStateNotifierProvider.notifier)
          .dataHandler(false, 'No Department available');
    }
    departmentsData =
        data.data['Project_Management_Process_department_creation'];

    try {
      departments = departmentsData
          .map((e) => ProjectManagementProcessDepartmentCreation.fromJson(e))
          .toList();
      Helper.departmentList = [];
      Helper.filterDepartment = {};
      for (var element in departments) {
        if (element.group != 'Ceo') {
          Helper.departmentList.add(element.id! + '*' + element.group!);
          Helper.filterDepartment[element.id] = element.group;
        }
      }
      return departments;
    } catch (e) {
      rethrow;
    }
  }

  getProjectAssignUser(List<String> value) async {
    List<ProjectManagementProcessProjectAssignUserList> departments = [];
    List<ProjectManagementProcessProjectAssignUserList> tempUserList = [];
    List<TaskAssign> assignList = [];
    List<dynamic> userData;
    List<dynamic> assignHrs;
    List<dynamic> tempList;
    QueryOptions options = QueryOptions(
      document: gql(projectAssignUser),
      variables: {
        'assigned_id': Helper.sharedCreatedId,
        'project_id': value[0],
        'task_id': value[1],
      },
    );
    final data = await getQueryResult(projectAssignUser, queryOptions: options);
    userData = data.data['item'];
    assignHrs = data.data['Project_Management_Process_task_assign'];
    tempList = data.data['item1'];
    try {
      departments = userData
          .map((e) => ProjectManagementProcessProjectAssignUserList.fromJson(e))
          .toList();
      assignList = assignHrs.map((e) => TaskAssign.fromJson(e)).toList();
      tempUserList = tempList
          .map((e) => ProjectManagementProcessProjectAssignUserList.fromJson(e))
          .toList();
      for (var data in tempUserList) {
        departments.add(data);
      }
      return TaskAssignUserList(
          processProjectAssignUserList: departments, taskAssign: assignList);
    } catch (e) {
      rethrow;
    }
  }

  getTeams(var departmentId) async {
    List<ProjectManagementProcessTeamCreation> teams = [];
    List<dynamic> teamData;
    QueryOptions options = QueryOptions(
      document: gql(getTeamDetails),
      variables: {
        '_eq': departmentId,
      },
    );
    final data = await getQueryResult(getTeamDetails, queryOptions: options);
    if (data != null) {
      ref
          .read(exceptionHandleStateNotifierProvider.notifier)
          .dataHandler(false, 'No Team available');
    }
    teamData = data.data['Project_Management_Process_team_creation'];
    try {
      teams = teamData
          .map((e) => ProjectManagementProcessTeamCreation.fromJson(e))
          .toList();
      Helper.teamList = [];
      Helper.filterTeam = {};
      for (var element in teams) {
        Helper.teamList
            .add(element.id! + '*' + element.teamName! + '*' + element.icon!);
        Helper.filterTeam[element.id!] = element.teamName!;
      }

      return teams;
    } catch (e) {
      rethrow;
    }
  }

  getCommentsData(var projectId) async {
    List<ProjectManagementProcessProjectComment> commentList = [];
    List<dynamic> teamData;
    QueryOptions options = QueryOptions(
      document: gql(getCommentsQuery),
      variables: {
        '_eq': projectId,
      },
    );
    final data = await getQueryResult(getCommentsQuery, queryOptions: options);
    if (data != null) {}
    teamData = data.data['Project_Management_Process_project_comments'];
    try {
      commentList = teamData
          .map((e) => ProjectManagementProcessProjectComment.fromJson(e))
          .toList();
      return commentList;
    } catch (e) {
      rethrow;
    }
  }

  getUserList() async {
    List<dynamic> userData;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getCreatedUser),
      variables: {
        '_eq': id,
      },
    );
    final data = await getQueryResult(getCreatedUser, queryOptions: options);
    userData = data.data['Project_Management_Process_user_registration'];
    List<ProjectManagementProcessUserRegistration> loginModel = userData
        .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
        .toList();
    try {
      return loginModel;
    } catch (e) {
      rethrow;
    }
  }

  getRatingValue(String empCode) async {
    List<dynamic> userData;
    QueryOptions options = QueryOptions(
      document: gql(getCreatedUser),
      variables: {
        '_eq': empCode,
      },
    );
    final data = await getQueryResult(getCreatedUser, queryOptions: options);
    userData = data.data['Project_Management_Process_user_registration'];
    List<ProjectManagementProcessUserRegistration> loginModel = userData
        .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
        .toList();
    try {
      return loginModel;
    } catch (e) {
      rethrow;
    }
  }

  getUserListTeam() async {
    List<dynamic> item1;
    List<dynamic> item2;
    List<ProjectManagementProcessUserRegistration> userDataList = [];
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getCreatedUserByTeam),
      variables: {
        '_eq': id,
      },
    );
    try {
      final data =
          await getQueryResult(getCreatedUserByTeam, queryOptions: options);
      item1 = data.data['item1'];
      item2 = data.data['item2'];
      List<ProjectManagementProcessUserRegistration> userItem1 = item1
          .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
          .toList();
      List<ProjectManagementProcessUserRegistration> userItem2 = item2
          .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
          .toList();
      for (var element in userItem1) {
        userDataList.add(element);
      }
      for (var element in userItem2) {
        userDataList.add(element);
      }

      return userDataList;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getUserFilterListTeam(String id) async {
    List<dynamic> item1;
    QueryOptions options = QueryOptions(
      document: gql(getTeamListQuery),
      variables: {
        '_eq': id,
      },
    );
    try {
      final data =
          await getQueryResult(getTeamListQuery, queryOptions: options);
      item1 = data.data['Project_Management_Process_user_registration'];
      List<ProjectManagementProcessUserRegistration> userItem1 = item1
          .map((e) => ProjectManagementProcessUserRegistration.fromJson(e))
          .toList();
      return userItem1;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getIndividualReportTeam(List<String> id) async {
    List<dynamic> item1;
    QueryOptions options = QueryOptions(
      document: gql(getIndividualReportQuery),
      variables: {
        '_eq': id[0],
        '_date': id[1],
      },
    );
    try {
      final data =
          await getQueryResult(getIndividualReportQuery, queryOptions: options);
      item1 = data.data['Project_Management_Process_daily_report'];
      List<IndividualReportProjectManagementProcessDailyReport> userItem1 =
          item1
              .map((e) =>
                  IndividualReportProjectManagementProcessDailyReport.fromJson(
                      e))
              .toList();
      return userItem1;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getProjectListDepartmentHead() async {
    List<dynamic> project;
    var id = Helper.shareddepId;
    QueryOptions options = QueryOptions(
      document: gql(getProjectDetails),
      variables: {
        '_eq': id,
      },
    );
    final data = await getQueryResult(getProjectDetails, queryOptions: options);
    project = data.data['Project_Management_Process_project_creation'];
    List<ProjectManagementProcessProjectCreationDetails> projectList = project
        .map((e) => ProjectManagementProcessProjectCreationDetails.fromJson(e))
        .toList();

    try {
      return projectList;
    } catch (e) {
      rethrow;
    }
  }

  getTaskList(var projectId) async {
    List<dynamic> task;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getTaskListDetailsQuery),
      variables: {
        'created_id': id,
        'project_id': projectId,
      },
    );
    final data =
        await getQueryResult(getTaskListDetailsQuery, queryOptions: options);
    task = data.data['Project_Management_Process_task_creation'];
    List<TaskDetailsModel> taskList =
        task.map((e) => TaskDetailsModel.fromJson(e)).toList();
    final totalPlannedHrs =
        data.data['Project_Management_Process_task_creation_aggregate']
            ['aggregate']['sum']['planned_hrs'];
    try {
      return TaskCreationList(
          projectManagementProcessTaskCreation: taskList,
          totalPlannedHrs: totalPlannedHrs);
    } catch (e) {
      rethrow;
    }
  }

  getTaskManagerList(var projectId) async {
    List<dynamic> task;
    var id = Helper.sharedCreatedId;
    QueryOptions options = QueryOptions(
      document: gql(getTaskManagerListDetailsQuery),
      variables: {
        'created_id': id,
        'project_id': projectId,
      },
    );

    try {
      final data = await getQueryResult(getTaskManagerListDetailsQuery,
          queryOptions: options);
      task = data.data['Project_Management_Process_task_creation'];
      List<TaskDetailsManagerCreation> taskList =
          task.map((e) => TaskDetailsManagerCreation.fromJson(e)).toList();
      final totalPlannedHrs =
          data.data['Project_Management_Process_task_creation_aggregate']
              ['aggregate']['sum']['planned_hrs'];
      return TaskCreationManagerList(
          taskCreationManager: taskList, plannedHrs: totalPlannedHrs);
    } catch (e) {
      rethrow;
    }
  }

  getProjectFilterListDepartmentHead(List<String> value) async {
    List<dynamic> project;
    var id = Helper.shareddepId;
    QueryOptions options = QueryOptions(
      document: gql(getFilterProjectDetails),
      variables: {
        '_eq': id,
        '_date': value[0],
        '_status': value[1],
      },
    );
    final data =
        await getQueryResult(getFilterProjectDetails, queryOptions: options);
    project = data.data['Project_Management_Process_project_creation'];
    List<ProjectManagementProcessProjectCreationDetails> projectList = project
        .map((e) => ProjectManagementProcessProjectCreationDetails.fromJson(e))
        .toList();

    try {
      return projectList;
    } catch (e) {
      rethrow;
    }
  }

  getProjectFilterIndividualDepartmentHead(var value) async {
    List<dynamic> project;
    QueryOptions options = QueryOptions(
      document: gql(getFilterIndividualProjectDetailsDepHeadQuery),
      variables: {
        '_project_id': value,
      },
    );

    try {
      final data =
      await getQueryResult(getFilterIndividualProjectDetailsDepHeadQuery, queryOptions: options);
      project = data.data['Project_Management_Process_project_creation'];
      List<ProjectManagementProcessProjectCreationDetails> projectList = project
          .map((e) => ProjectManagementProcessProjectCreationDetails.fromJson(e))
          .toList();

      return projectList;
    } catch (e) {
      rethrow;
    }
  }



  getProjectList() async {
    List<dynamic> project;
    QueryOptions options = QueryOptions(
      document: gql(getProjectDetailsSuperAdmin),
    );
    try {
      final data = await getQueryResult(getProjectDetailsSuperAdmin,
          queryOptions: options);
      project = data.data['Project_Management_Process_project_creation'];
      List<ProjectManagementProcessProjectCreation> projectList = project
          .map((e) => ProjectManagementProcessProjectCreation.fromJson(e))
          .toList();
      print(data);
      return projectList;
    } catch (e) {
      return e;
    }
  }

  getProjectCodeList(String id) async {
    List<dynamic> project;
    QueryOptions options = QueryOptions(
      document: gql(getProjectCodeDetails),
      variables: {
        '_eq': id,
      },
    );
    final data =
        await getQueryResult(getProjectCodeDetails, queryOptions: options);
    project = data.data['Project_Management_Process_project_creation'];
    List<ProjectManagementProcessProjectCreation> projectList = project
        .map((e) => ProjectManagementProcessProjectCreation.fromJson(e))
        .toList();

    try {
      return projectList;
    } catch (e) {
      rethrow;
    }
  }

  getPerformance() async {
    QueryOptions options = QueryOptions(
      document: gql(performanceQuery),
      variables: {
        '_eq': Helper.sharedCreatedId,
      },
    );
    final data = await getQueryResult(performanceQuery, queryOptions: options);
    try {
      final dpiTotal = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final dpiAvg = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['avg']['rating'];
      final dpiCount = data.data[
              'Project_Management_Process_daily_performance_index_aggregate']
          ['aggregate']['count'];
      final spiTotal = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['sum']['rating'];
      final spiAvg = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['avg']['rating'];
      final spiCount = data.data[
              'Project_Management_Process_supervisors_performance_index_aggregate']
          ['aggregate']['count'];
      final qpiTotal = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['sum']['rating_value'];
      final qpiAvg = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['avg']['rating_value'];
      final qpiCount = data.data[
              'Project_Management_Process_quality_performance_index_aggregate']
          ['aggregate']['count'];
      final priTotal =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['sum']['rating'];
      final priAvg =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['avg']['rating'];
      final priCount =
          data.data['Project_Management_Process_productivity_index_aggregate']
              ['aggregate']['count'];

      return CumulativeModel(
          dpiTotal: dpiTotal,
          dpiAvg: dpiAvg,
          dpicount: dpiCount,
          spiTotal: spiTotal,
          spiAvg: spiAvg,
          spicount: spiCount,
          qpiTotal: qpiTotal,
          qpiAvg: qpiAvg,
          qpicount: qpiCount,
          priTotal: priTotal,
          priAvg: priAvg,
          pricount: priCount);
    } catch (e) {
      print(e);
    }
  }

  deleteUser(String employeCode) async {
    try {
      MutationOptions options = MutationOptions(
          document: gql(deleteQuery),
          variables: {'employe_code': employeCode, 'is_active': false},
          onCompleted: (data) {
            ref.refresh(userListStateProvider);
          });
      final result = _getMutationResult(deleteQuery, mutationOptions: options);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  getRatingList() async {
    final result = await getQueryResult(queryRatingList);
    List<RatingModel> ratingList = [];
    for (dynamic element
        in result.data['Project_Management_Process_rating_title']) {
      ratingList.add(RatingModel(
        title: element['name'],
        description: element['description'],
        maxValue: element['maxvalue'],
        ratingId: element['title_id'],
      ));
    }
    print(result.toString());
    return ratingList;
  }

  updateRating(String empId, var depId, var teamId, RatingValue ratingModel,
      var total) async {
    var ratedBy = Helper.sharedCreatedId;
    var result;
    try {
      if (Helper.sharedRoleId == 'TeamMember' ||
          Helper.sharedRoleId == 'TeamLead') {
        MutationOptions options =
            MutationOptions(document: gql(mutationRating), variables: {
          "ratedBy": ratedBy,
          "userId": empId,
          "teamid": teamId,
          "departmentid": depId,
          "workstation_neatness": ratingModel.workstation_neatness,
          "smartness": ratingModel.smartness,
          "quality_of_work": ratingModel.quality_of_work,
          "on_time_delivery": ratingModel.on_time_delivery,
          "punctuality": ratingModel.punctuality,
          "attitude": ratingModel.attitude,
          "total_rating_value": total,
        });
        result =
            await _getMutationResult(mutationRating, mutationOptions: options);
      } else {
        MutationOptions options =
            MutationOptions(document: gql(mutationManagerRating), variables: {
          "ratedBy": ratedBy,
          "userId": empId,
          "departmentid": depId,
          "workstation_neatness": ratingModel.workstation_neatness,
          "smartness": ratingModel.smartness,
          "quality_of_work": ratingModel.quality_of_work,
          "on_time_delivery": ratingModel.on_time_delivery,
          "punctuality": ratingModel.punctuality,
          "attitude": ratingModel.attitude,
          "total_rating_value": total,
        });
        result = await _getMutationResult(mutationManagerRating,
            mutationOptions: options);
      }
      return result
              .data!['insert_Project_Management_Process_rating_performance']
          ['returning'][0]['id'];
    } catch (e) {
      return e;
    }
  }

  checkRatingDate(String empId) async {
    bool isChecked = false;
   var  createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
    QueryOptions options = QueryOptions(
        document: gql(queryCheckSupervisorsRatingDate),
        variables: {'userId': empId, 'date': createdDate});
    final result = await getQueryResult(queryCheckSupervisorsRatingDate,
        queryOptions: options);

    List<dynamic> data = await result
        .data['Project_Management_Process_supervisors_performance_index'];
    List<dynamic> data1 =
        await result.data['Project_Management_Process_daily_performance_index'];
    if (data1.isNotEmpty && data.isNotEmpty) {
      isChecked = true;
    }
    return isChecked;
  }

  checkRatingDateSend(String empId,var date) async {
   bool isChecked = false;
    QueryOptions options = QueryOptions(
        document: gql(queryCheckSupervisorsRatingDate),
        variables: {'userId': empId, 'date': date});
    final result = await getQueryResult(queryCheckSupervisorsRatingDate,
        queryOptions: options);

    List<dynamic> data = await result
        .data['Project_Management_Process_supervisors_performance_index'];
    List<dynamic> data1 =
    await result.data['Project_Management_Process_daily_performance_index'];
    if (data1.isNotEmpty && data.isNotEmpty) {
       isChecked = true;
    }
    return isChecked;
  }
}
