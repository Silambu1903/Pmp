// ignore_for_file: prefer_if_null_operators

import 'package:pmp/model/projectmanagementdetails.dart';

class ProjectManagementProcessProjectAssignTeam {
  ProjectManagementProcessProjectAssignTeam(
      {this.assignedDate,
      this.assignedId,
      this.isActive,
      this.id,
      this.projectId,
      this.projectCreation,
      this.assignHr});

  DateTime? assignedDate;
  String? assignedId;
  bool? isActive;
  String? id;
  String? projectId;
  ProjectCreationAssignedTeam? projectCreation;
  AssignHrDaily? assignHr;

  factory ProjectManagementProcessProjectAssignTeam.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessProjectAssignTeam(
        assignedDate: DateTime.parse(json["assigned_date"]),
        assignedId: json["assigned_id"],
        isActive: json["is_active"],
        id: json["id"],
        projectId: json["project_id"],
        projectCreation:
            ProjectCreationAssignedTeam.fromJson(json["project_creation"]),
        assignHr: json["assign_hr"] == null
            ? AssignHrDaily(assignHrs: '')
            : AssignHrDaily.fromJson(json["assign_hr"]),
      );

  Map<String, dynamic> toJson() => {
        "assigned_date":
            "${assignedDate!.year.toString().padLeft(4, '0')}-${assignedDate!.month.toString().padLeft(2, '0')}-${assignedDate!.day.toString().padLeft(2, '0')}",
        "assigned_id": assignedId,
        "is_active": isActive,
        "id": id,
        "project_id": projectId,
        "project_creation": projectCreation!.toJson(),
        "assign_hr": assignHr!.toJson(),
      };
}

class ProjectCreationAssignedTeam {
  ProjectCreationAssignedTeam({
    this.projectCode,
    this.projectName,
    this.plannedHrs,
    this.isActive,
    this.description,
    this.deparmentId,
    this.deliveryDate,
    this.createDate,
    this.allocationProjects,
    this.projectAssigns,
    this.id,
    this.spentHrs,
    this.status,
    this.updateDate,
    this.projectComments
  });

  String? projectCode;
  String? projectName;
  String? plannedHrs;
  bool? isActive;
  var spentHrs;
  String? description;
  String? deparmentId;
  String? deliveryDate;
  String? status;
  DateTime? createDate;
  List<AllocationProjectAssignedTeam>? allocationProjects;
  List<ProjectAssignId>? projectAssigns;
  List<ProjectComment>? projectComments;
  String? id;
  DateTime? updateDate;

  factory ProjectCreationAssignedTeam.fromJson(Map<String, dynamic> json) =>
      ProjectCreationAssignedTeam(
        projectCode: json["project_code"],
        projectName: json["project_name"],
        plannedHrs: json["planned_hrs"],
        isActive: json["is_active"],
        description: json["description"],
        status: json["status"],
        spentHrs: json["daily_reports_aggregate"]["aggregate"]["sum"]["spent_hrs"]??0,
        deparmentId: json["deparment_id"],
        deliveryDate: json["delivery_date"],
        createDate: DateTime.parse(json["create_date"]),
        allocationProjects: List<AllocationProjectAssignedTeam>.from(
            json["allocation_projects"]
                .map((x) => AllocationProjectAssignedTeam.fromJson(x))),
        id: json["id"],
        projectAssigns: List<ProjectAssignId>.from(
            json["project_assigns"].map((x) => ProjectAssignId.fromJson(x))),
        projectComments: List<ProjectComment>.from(
            json["project_comments"].map((x) => ProjectComment.fromJson(x))),
        // updateDate: DateTime.parse(json["update_date"]),
      );

  Map<String, dynamic> toJson() => {
        "project_code": projectCode,
        "project_name": projectName,
        "planned_hrs": plannedHrs,
        "is_active": isActive,
        "description": description,
        "status": status,
        "deparment_id": deparmentId,
        "delivery_date": deliveryDate,
        "create_date":
            "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
        "allocation_projects":
            List<dynamic>.from(allocationProjects!.map((x) => x.toJson())),
        "id": id,
        "project_assigns":
            List<dynamic>.from(projectAssigns!.map((x) => x.toJson())),
    "project_comments":
    List<dynamic>.from(projectComments!.map((x) => x.toJson())),
        "update_date":
            "${updateDate!.year.toString().padLeft(4, '0')}-${updateDate!.month.toString().padLeft(2, '0')}-${updateDate!.day.toString().padLeft(2, '0')}",
      };
}

class AllocationProjectAssignedTeam {
  AllocationProjectAssignedTeam({
    this.isActive,
    this.plannedHrs,
    this.createdId,
    this.createdDate,
    this.projectId,
    this.teamId,
    this.id,
  });

  bool? isActive;
  String? plannedHrs;
  String? createdId;
  DateTime? createdDate;
  String? projectId;
  String? teamId;
  String? id;

  factory AllocationProjectAssignedTeam.fromJson(Map<String, dynamic> json) =>
      AllocationProjectAssignedTeam(
        isActive: json["is_active"],
        plannedHrs: json["planned_hrs"],
        createdId: json["created_id"],
        createdDate: DateTime.parse(json["created_date"]),
        projectId: json["project_id"],
        teamId: json["team_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "planned_hrs": plannedHrs,
        "created_id": createdId,
        "created_date":
            "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
        "project_id": projectId,
        "team_id": teamId,
        "id": id,
      };
}

class AssignHr {
  AssignHr({
    this.assignId,
    this.assignHrs,
  });

  String? assignId;
  String? assignHrs;

  factory AssignHr.fromJson(Map<String, dynamic> json) => AssignHr(
        assignId: json["id"],
        assignHrs: json["assign_hrs"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": assignId,
        "assign_hrs": assignHrs,
      };
}

class ProjectAssignId {
  ProjectAssignId(
      {this.userId, this.assignedHrs, this.assignHr});

  String? userId;
  bool? assignedHrs;
  AssignHr? assignHr;

  factory ProjectAssignId.fromJson(Map<String, dynamic> json) =>
      ProjectAssignId(
        userId: json["user_id"],
        assignedHrs: json["assigned_hrs"],
        assignHr: json["assign_hr"] == null
            ? AssignHr(assignHrs: '')
            : AssignHr.fromJson(json["assign_hr"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "assigned_hrs": assignedHrs,
        "assign_hr": assignHr!.toJson(),
      };
}

class AssignHrDaily {
  AssignHrDaily({
    this.assignId,
    this.assignHrs,
  });

  String? assignId;
  String? assignHrs;

  factory AssignHrDaily.fromJson(Map<String, dynamic> json) => AssignHrDaily(
    assignId: json["id"],
    assignHrs: json["assign_hrs"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": assignId,
    "assign_hrs": assignHrs,
  };
}
