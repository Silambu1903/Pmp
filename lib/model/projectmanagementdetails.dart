import 'package:pmp/model/projectmanagementprojectmanager.dart';

class ProjectManagementProcessProjectCreationDetails {
  ProjectManagementProcessProjectCreationDetails(
      {this.createDate,
      this.deliveryDate,
      this.deparmentId,
      this.description,
      this.id,
      this.isActive,
      this.plannedHrs,
      this.projectCode,
      this.projectName,
      this.status,
      this.updateDate,
      this.projectAssigns,
      this.allocationProjects,
      this.projectComments});

  DateTime? createDate;
  String? deliveryDate;
  String? deparmentId;
  String? description;
  String? id;
  bool? isActive;
  String? plannedHrs;
  String? projectCode;
  String? projectName;
  String? status;
  DateTime? updateDate;
  List<AllocationProjectDetails>? allocationProjects;
  List<ProjectAssignDetails>? projectAssigns;
  List<ProjectComment>? projectComments;

  factory ProjectManagementProcessProjectCreationDetails.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessProjectCreationDetails(
        createDate: DateTime.parse(json["create_date"]),
        deliveryDate: json["delivery_date"],
        deparmentId: json["deparment_id"],
        description: json["description"],
        id: json["id"],
        isActive: json["is_active"],
        plannedHrs: json["planned_hrs"],
        projectCode: json["project_code"],
        projectName: json["project_name"],
        status: json["status"],
        updateDate: DateTime.parse(json["update_date"]),
        allocationProjects: List<AllocationProjectDetails>.from(
            json["allocation_projects"]
                .map((x) => AllocationProjectDetails.fromJson(x))),
        projectAssigns: List<ProjectAssignDetails>.from(json["project_assigns"]
            .map((x) => ProjectAssignDetails.fromJson(x))),
        projectComments: List<ProjectComment>.from(
            json["project_comments"].map((x) => ProjectComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "create_date":
            "${createDate!.year.toString().padLeft(4, '0')}-${createDate!.month.toString().padLeft(2, '0')}-${createDate!.day.toString().padLeft(2, '0')}",
        "delivery_date": deliveryDate,
        "deparment_id": deparmentId,
        "description": description,
        "id": id,
        "is_active": isActive,
        "planned_hrs": plannedHrs,
        "project_code": projectCode,
        "project_name": projectName,
        "status": status,
        "allocation_projects":
            List<dynamic>.from(allocationProjects!.map((x) => x.toJson())),
        "update_date":
            "${updateDate!.year.toString().padLeft(4, '0')}-${updateDate!.month.toString().padLeft(2, '0')}-${updateDate!.day.toString().padLeft(2, '0')}",
        "project_assigns":
            List<dynamic>.from(projectAssigns!.map((x) => x.toJson())),
        "project_comments":
            List<dynamic>.from(projectComments!.map((x) => x.toJson())),
      };
}

class AllocationProjectDetails {
  AllocationProjectDetails(
      {this.teamId,
      this.projectId,
      this.plannedHrs,
      this.isActive,
      this.id,
      this.createdId,
      this.createdDate,
      this.teamCreation});

  String? teamId;
  String? projectId;
  String? plannedHrs;
  bool? isActive;
  String? id;
  String? createdId;
  DateTime? createdDate;
  TeamCreation? teamCreation;

  factory AllocationProjectDetails.fromJson(Map<String, dynamic> json) =>
      AllocationProjectDetails(
        teamId: json["team_id"],
        projectId: json["project_id"],
        plannedHrs: json["planned_hrs"],
        isActive: json["is_active"],
        id: json["id"],
        createdId: json["created_id"],
        createdDate: DateTime.parse(json["created_date"]),
        teamCreation: TeamCreation.fromJson(json["team_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "team_id": teamId,
        "project_id": projectId,
        "planned_hrs": plannedHrs,
        "is_active": isActive,
        "id": id,
        "created_id": createdId,
        "team_creation": teamCreation!.toJson(),
        "created_date":
            "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
      };
}

class ProjectAssignDetails {
  ProjectAssignDetails(
      {this.userId,
      this.projectId,
      this.id,
      this.assignedId,
      this.assignedDate,
      this.isActive,
      this.assignHr});

  String? userId;
  String? projectId;
  String? id;
  String? assignedId;
  DateTime? assignedDate;
  bool? isActive;
  AssignHrMananger? assignHr;

  factory ProjectAssignDetails.fromJson(Map<String, dynamic> json) =>
      ProjectAssignDetails(
        userId: json["user_id"],
        projectId: json["project_id"],
        id: json["id"],
        assignedId: json["assigned_id"],
        assignedDate: DateTime.parse(json["assigned_date"]),
        isActive: json["is_active"],
        assignHr: json["assign_hr"] == null
            ? AssignHrMananger(assignHrs: '')
            : AssignHrMananger.fromJson(json["assign_hr"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "project_id": projectId,
        "id": id,
        "assigned_id": assignedId,
        "assigned_date":
            "${assignedDate!.year.toString().padLeft(4, '0')}-${assignedDate!.month.toString().padLeft(2, '0')}-${assignedDate!.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "assign_hr": assignHr ?? '',
      };
}

class TeamCreation {
  TeamCreation({
    this.teamName,
  });

  String? teamName;

  factory TeamCreation.fromJson(Map<String, dynamic> json) => TeamCreation(
        teamName: json["team_name"],
      );

  Map<String, dynamic> toJson() => {
        "team_name": teamName,
      };
}

class ProjectComment {
  ProjectComment({
    this.userRegistration,
    this.comment,
  });

  UserRegistration? userRegistration;
  String? comment;

  factory ProjectComment.fromJson(Map<String, dynamic> json) => ProjectComment(
        userRegistration: json["user_registration"] != null
            ? UserRegistration.fromJson(json["user_registration"])
            : UserRegistration(userName: ''),
        comment: json["comment"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_registration": userRegistration!.toJson(),
        "comment": comment,
      };
}

class UserRegistration {
  UserRegistration({
    this.userName,
  });

  String? userName;

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      UserRegistration(
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
      };
}
