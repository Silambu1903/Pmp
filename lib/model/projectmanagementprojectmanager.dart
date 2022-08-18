import 'package:pmp/model/projectmanagementdetails.dart';
import 'package:pmp/model/projectmanagmentprojectallassignedproject.dart';

class ProjectManagementProcessProjectAssignManager {
  ProjectManagementProcessProjectAssignManager(
      {this.assignedDate,
      this.assignedId,
      this.isActive,
      this.id,
      this.projectId,
      this.projectCreation,
      this.assignHr,
      this.userId});

  DateTime? assignedDate;
  String? assignedId;
  bool? isActive;
  String? id;
  String? userId;
  String? projectId;
  ProjectCreationManager? projectCreation;
  AssignHrMananger? assignHr;

  factory ProjectManagementProcessProjectAssignManager.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessProjectAssignManager(
        assignedDate: DateTime.parse(json["assigned_date"]),
        assignedId: json["assigned_id"],
        isActive: json["is_active"],
        projectId: json["project_id"],
        userId: json["user_id"],
        id: json["id"],
        projectCreation:
            ProjectCreationManager.fromJson(json["project_creation"]),
        assignHr: json["assign_hr"] == null
            ? AssignHrMananger(assignHrs: '')
            : AssignHrMananger.fromJson(json["assign_hr"]),
      );

  Map<String, dynamic> toJson() => {
        "assigned_date":
            "${assignedDate!.year.toString().padLeft(4, '0')}-${assignedDate!.month.toString().padLeft(2, '0')}-${assignedDate!.day.toString().padLeft(2, '0')}",
        "assigned_id": assignedId,
        "is_active": isActive,
        "id": id,
        "user_id": userId,
        "project_id": projectId,
        "project_creation": projectCreation!.toJson(),
        "assign_hr": assignHr!.toJson(),
      };
}

class ProjectCreationManager {
  ProjectCreationManager(
      {this.projectCode,
      this.projectName,
      this.plannedHrs,
      this.isActive,
      this.description,
      this.deparmentId,
      this.deliveryDate,
      this.status,
      this.createDate,
      this.projectAssigns,
      this.projectComments,
      this.allocationProjects});

  String? projectCode;
  String? projectName;
  String? plannedHrs;
  bool? isActive;
  String? description;
  String? status;
  String? deparmentId;
  String? deliveryDate;
  DateTime? createDate;
  List<AllocationProjectManager>? allocationProjects;
  List<ProjectAssignId>? projectAssigns;
  List<ProjectComment>? projectComments;

  factory ProjectCreationManager.fromJson(Map<String, dynamic> json) =>
      ProjectCreationManager(
        projectCode: json["project_code"],
        projectName: json["project_name"],
        plannedHrs: json["planned_hrs"],
        isActive: json["is_active"],
        status: json["status"],
        description: json["description"],
        deparmentId: json["deparment_id"],
        deliveryDate: json["delivery_date"],
        createDate: DateTime.parse(json["create_date"]),
        allocationProjects: List<AllocationProjectManager>.from(
            json["allocation_projects"]
                .map((x) => AllocationProjectManager.fromJson(x))),
        projectAssigns: List<ProjectAssignId>.from(
            json["project_assigns"].map((x) => ProjectAssignId.fromJson(x))),
        projectComments: List<ProjectComment>.from(
            json["project_comments"].map((x) => ProjectComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project_code": projectCode,
        "project_name": projectName,
        "planned_hrs": plannedHrs,
        "is_active": isActive,
        "description": description,
        "deparment_id": deparmentId,
        "status": status,
        "allocation_projects":
            List<dynamic>.from(allocationProjects!.map((x) => x.toJson())),
        "delivery_date": deliveryDate,
        "project_assigns":
            List<dynamic>.from(projectAssigns!.map((x) => x.toJson())),
        "create_date":
            "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
      };
}

class AllocationProjectManager {
  AllocationProjectManager({
    this.plannedHrs,
    this.teamCreation,
  });

  String? plannedHrs;
  TeamCreation? teamCreation;

  factory AllocationProjectManager.fromJson(Map<String, dynamic> json) =>
      AllocationProjectManager(
        plannedHrs: json["planned_hrs"],
        teamCreation: TeamCreation.fromJson(json["team_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "planned_hrs": plannedHrs,
        "team_creation": teamCreation!.toJson(),
      };
}

class AssignHrMananger {
  AssignHrMananger({
    this.assignHrs,
  });

  String? assignHrs;

  factory AssignHrMananger.fromJson(Map<String, dynamic> json) =>
      AssignHrMananger(
        assignHrs: json["assign_hrs"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "assign_hrs": assignHrs,
      };
}
