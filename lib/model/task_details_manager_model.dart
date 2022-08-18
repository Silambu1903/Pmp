class TaskCreationManagerList{
  List<TaskDetailsManagerCreation> ? taskCreationManager;
  var plannedHrs;

  TaskCreationManagerList({this.taskCreationManager, this.plannedHrs});
}


class TaskDetailsManagerCreation {
  TaskDetailsManagerCreation({
    this.teamId,
    this.taskName,
    this.taskDescription,
    this.projectId,
    this.plannedHrs,
    this.date,
    this.createdId,
    this.id,
    this.taskAssigns,
  });

  String? teamId;
  String ?taskName;
  String ?taskDescription;
  String ?projectId;
  int ?plannedHrs;
  String? date;
  String ?createdId;
  String ?id;
  List<TaskManagerAssign> ?taskAssigns;

  factory TaskDetailsManagerCreation.fromJson(Map<String, dynamic> json) => TaskDetailsManagerCreation(
    teamId: json["team_id"],
    taskName: json["task_name"],
    taskDescription: json["task_description"],
    projectId: json["project_id"],
    plannedHrs: json["planned_hrs"],
    date: json["date"],
    createdId: json["created_id"],
    id: json["id"],
    taskAssigns: List<TaskManagerAssign>.from(json["task_assigns"].map((x) => TaskManagerAssign.fromJson(x))),
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
    "task_assigns": List<dynamic>.from(taskAssigns!.map((x) => x.toJson())),
  };
}

class TaskManagerAssign {
  TaskManagerAssign({
    this.taskAssignHrs,
    this.id,
    this.date,
  });

  int ?taskAssignHrs;
  String? id;
  String ?date;

  factory TaskManagerAssign.fromJson(Map<String, dynamic> json) => TaskManagerAssign(
    taskAssignHrs: json["task_assign_hrs"],
    id: json["id"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "task_assign_hrs": taskAssignHrs,
    "id": id,
    "date": date,
  };
}
