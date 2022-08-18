import 'login_model.dart';

class TaskAssignUserList {
  List<ProjectManagementProcessProjectAssignUserList>?
      processProjectAssignUserList;
  List<TaskAssign>? taskAssign;

  TaskAssignUserList({this.processProjectAssignUserList, this.taskAssign});
}

class ProjectManagementProcessProjectAssignUserList {
  ProjectManagementProcessProjectAssignUserList(
      {this.id, this.userRegistration, this.taskAssign});

  String? id;
  ProjectManagementProcessUserRegistration? userRegistration;
  TaskAssign? taskAssign;

  factory ProjectManagementProcessProjectAssignUserList.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessProjectAssignUserList(
        id: json["id"],
        taskAssign: json["task_assigns"],
        userRegistration: ProjectManagementProcessUserRegistration.fromJson(
            json["user_registration"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_registration": userRegistration!.toJson(),
      };
}

class TaskAssign {
  String? id;
  var taskAssignHrs;
  ProjectManagementProcessUserRegistration? userRegistration;

  TaskAssign({this.id, this.taskAssignHrs, this.userRegistration});

  factory TaskAssign.fromJson(Map<String, dynamic> json) => TaskAssign(
      id: json['id'],
      taskAssignHrs: json["task_assign_hrs"] ?? 0,
      userRegistration: ProjectManagementProcessUserRegistration.fromJson(
          json["userRegistrationByAssigneeToId"]));

  Map<String, dynamic> toJson() => {
        "task_assign_hrs": taskAssignHrs,
        "id": id,
        "user_registration": userRegistration!.toJson(),
      };
}
