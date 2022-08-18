class ProjectManagementProcessProjectAssign {
  ProjectManagementProcessProjectAssign({
    this.isActive,
    this.id,
    this.assignedId,
    this.assignedDate,
    this.userId,
    this.projectId,
    this.assignedHours,
    this.assignedHourBool
  });

  dynamic isActive;
  String ? id;
  dynamic assignedId;
  dynamic assignedDate;
  dynamic userId;
  dynamic assignedHours;
  bool? assignedHourBool;
  dynamic projectId;

  factory ProjectManagementProcessProjectAssign.fromJson(Map<String, dynamic> json) => ProjectManagementProcessProjectAssign(
    isActive: json["is_active"],
    id: json["id"],
    assignedId: json["assigned_id"],
    assignedDate: json["assigned_date"],
    assignedHours: json["assign_hrs"],
    userId: json["user_id"],
    assignedHourBool: json["assigned_hrs"],
    projectId: json["project_id"],
  );

  Map<String, dynamic> toJson() => {
    "is_active": isActive,
    "id": id,
    "assigned_id": assignedId,
    "assigned_date": assignedDate,
    "user_id": userId,
    "assign_hrs": assignedHours,
    "project_id": projectId,
    "assigned_hrs": assignedHourBool,
  };
}
