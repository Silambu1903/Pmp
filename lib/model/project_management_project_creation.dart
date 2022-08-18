import 'package:pmp/model/projectmanagementdetails.dart';
import 'package:pmp/model/projectmanagementprojectmanager.dart';

class ProjectManagementProcessProjectCreation {
  ProjectManagementProcessProjectCreation(
      {this.updateDate,
      this.projectName,
      this.projectCode,
      this.plannedHrs,
      this.isActive,
      this.id,
      this.departmentId,
      this.description,
      this.deliveryDate,
      this.createDate,
      this.status,
      this.projectComments,
        this.projectWeightage,
        this.projectValue,
      this.allocationProjects});

  var updateDate;

  String? projectName;
  String? projectCode;
  String? plannedHrs;
  String? status;
  bool? isActive;
  String? id;
  String? description;
  var deliveryDate;
  var departmentId;
  var createDate;
  double ? projectWeightage;
  double ? projectValue;
  List<AllocationProjectManager>? allocationProjects;
  List<ProjectComment>? projectComments;

  factory ProjectManagementProcessProjectCreation.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessProjectCreation(
        createDate: DateTime.parse(json["create_date"]),
        deliveryDate: json["delivery_date"],
        id: json["id"],
        description: json["description"],
        departmentId: json["deparment_id"],
        isActive: json["is_active"],
        plannedHrs: json["planned_hrs"],
        projectCode: json["project_code"],
        projectName: json["project_name"],
        status: json["status"],
        projectWeightage: json["project_weightage"],
        projectValue: json["project_value"],
        updateDate: DateTime.parse(json["update_date"]),
        allocationProjects: List<AllocationProjectManager>.from(
            json["allocation_projects"]
                .map((x) => AllocationProjectManager.fromJson(x))),
        projectComments: List<ProjectComment>.from(
            json["project_comments"].map((x) => ProjectComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "create_date":
            "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
        "delivery_date": deliveryDate,
        "id": id,
        "description": description,
        "deparment_id": departmentId,
        "is_active": isActive,
        "planned_hrs": plannedHrs,
        "project_code": projectCode,
        "project_name": projectName,
        "status": status,
        "project_weightage": projectWeightage,
        "project_value": projectValue,
        "update_date":
            "${updateDate.year.toString().padLeft(4, '0')}-${updateDate.month.toString().padLeft(2, '0')}-${updateDate.day.toString().padLeft(2, '0')}",
        "allocation_projects":
            List<dynamic>.from(allocationProjects!.map((x) => x.toJson())),
        "project_comments":
            List<dynamic>.from(projectComments!.map((x) => x.toJson())),
      };
}
