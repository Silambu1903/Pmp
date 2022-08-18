class TaskCreationList {
  TaskCreationList({
    this.projectManagementProcessTaskCreation,
    this.totalPlannedHrs,
  });

  List<TaskDetailsModel>  ? projectManagementProcessTaskCreation;
  var totalPlannedHrs;

}


class TaskDetailsModel {
  String? id, date, taskName, taskDescription;
  var  teamId, projectId, createdId;
  var plannedHrs;

  TaskDetailsModel({this.id, this.date, this.taskName, this.taskDescription,
      this.teamId, this.projectId, this.createdId, this.plannedHrs});

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) => TaskDetailsModel(
    teamId: json["team_id"],
    taskName: json["task_name"],
    taskDescription: json["task_description"],
    projectId: json["project_id"],
    plannedHrs: json["planned_hrs"],
    date: json["date"],
    createdId: json["created_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "team_id": teamId,
    "task_name": taskName,
    "task_description": taskDescription,
    "project_id": projectId,
    "planned_hrs": plannedHrs,
    "date": date,
    "created_id": createdId,
    "id": id,
  };
}



