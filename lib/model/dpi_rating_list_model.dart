import 'package:pmp/model/projectmanagementprocessteamcreation.dart';

class DpiRatingDailyReport {
  DpiRatingDailyReport({
    this.userId,
    this.teamId,
    this.taskDetails,
    this.spentHrs,
    this.remarks,
    this.projectId,
    this.departmentId,
    this.createdDate,
    this.taskAssign,
    this.projectCreation
  });

  String? userId;
  String? teamId;
  String? taskDetails;
  double? spentHrs;
  String? remarks;
  String? projectId;
  String? departmentId;
  String? createdDate;
  DpiRatingTaskAssign? taskAssign;
  ProjectCreation? projectCreation;

  factory DpiRatingDailyReport.fromJson(Map<String, dynamic> json) =>
      DpiRatingDailyReport(
        userId: json["user_id"] ?? '',
        teamId: json["team_id"] ?? '',
        taskDetails: json["task_details"] ?? '',
        spentHrs: json["spent_hrs"].toDouble() ?? 0,
        remarks: json["remarks"] ?? '',
        projectId: json["project_id"] ?? '',
        departmentId: json["department_id"] ?? '',
        createdDate: json["created_date"] ?? '',
        taskAssign: json["task_assign"] == null
            ? DpiRatingTaskAssign()
            : DpiRatingTaskAssign.fromJson(json["task_assign"]),
        projectCreation: ProjectCreation.fromJson(json["project_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "team_id": teamId,
        "task_details": taskDetails,
        "spent_hrs": spentHrs,
        "remarks": remarks,
        "project_id": projectId,
        "department_id": departmentId,
        "created_date": createdDate,
        "task_assign": taskAssign == null ? null : taskAssign!.toJson(),
    "project_creation": projectCreation!.toJson(),
      };
}

class DpiRatingTaskAssign {
  DpiRatingTaskAssign({
    this.taskAssignHrs,
    this.taskId,
    this.id,
    this.taskCreation,
  });

  int? taskAssignHrs;
  var taskId;
  var id;
  DpiRatingTaskCreation? taskCreation;

  factory DpiRatingTaskAssign.fromJson(Map<String, dynamic> json) =>
      DpiRatingTaskAssign(
        taskAssignHrs: json["task_assign_hrs"] ?? 0,
        id: json["id"] ?? '',
        taskId: json["task_id"] ?? '',
        taskCreation: json["task_creation"] != null
            ? DpiRatingTaskCreation.fromJson(json["task_creation"])
            : DpiRatingTaskCreation(),
      );

  Map<String, dynamic> toJson() => {
        "task_assign_hrs": taskAssignHrs,
        "id": id,
        "task_id": taskId,
        "task_creation": taskCreation!.toJson(),
      };
}

class DpiRatingTaskCreation {
  DpiRatingTaskCreation({
    this.taskName,
  });

  String? taskName;

  factory DpiRatingTaskCreation.fromJson(Map<String, dynamic> json) =>
      DpiRatingTaskCreation(
        taskName: json["task_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "task_name": taskName,
      };
}
