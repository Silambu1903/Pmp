class ProjectManagementProcessDailyReport {
  ProjectManagementProcessDailyReport({
    this.userId,
    this.teamId,
    this.taskDetails,
    this.spentHrs,
    this.remarks,
    this.projectId,
    this.departmentId,
    this.createdDate,
    this.taskAssignId
  });

  dynamic userId;
  dynamic teamId;
  dynamic taskDetails;
  dynamic spentHrs;
  dynamic remarks;
  dynamic projectId;
  dynamic departmentId;
  dynamic createdDate;
  dynamic taskAssignId;

  factory ProjectManagementProcessDailyReport.fromJson(Map<String, dynamic> json) => ProjectManagementProcessDailyReport(
    userId: json["user_id"],
    teamId: json["team_id"],
    taskDetails: json["task_details"],
    spentHrs: json["spent_hrs"],
    remarks: json["remarks"],
    projectId: json["project_id"],
    departmentId: json["department_id"],
    createdDate: json["created_date"],
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
  };
}
