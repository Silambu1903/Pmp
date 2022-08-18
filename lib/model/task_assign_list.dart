class TaskAssignToUserList {
  TaskAssignToUserList({
    this.id,
    this.date,
    this.active,
    this.projectAssginId,
    this.taskAssignHrs,
    this.taskId,
    this.taskCreation,
  });

  String? id;
  String? date;
  bool? active;
  String? projectAssginId;
  var taskAssignHrs;
  String? taskId;
  TaskCreation? taskCreation;

  factory TaskAssignToUserList.fromJson(Map<String, dynamic> json) =>
      TaskAssignToUserList(
        id: json["id"] ?? '',
        date: json["date"] ?? '',
        active: json["active"] ?? false,
        projectAssginId: json["project_assgin_id"] ?? '',
        taskAssignHrs: json["task_assign_hrs"] ?? 0,
        taskId: json["task_id"] ?? '',
        taskCreation: TaskCreation.fromJson(json["task_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "active": active,
        "project_assgin_id": projectAssginId,
        "task_assign_hrs": taskAssignHrs,
        "task_id": taskId,
        "task_creation": taskCreation!.toJson(),
      };
}

class TaskCreation {
  TaskCreation({
    this.projectId,
    this.plannedHrs,
    this.taskName,
    this.taskDescription,
    this.id,
  });

  String? projectId;
  var plannedHrs;
  String? taskName;
  String? taskDescription;
  String? id;

  factory TaskCreation.fromJson(Map<String, dynamic> json) => TaskCreation(
        projectId: json["project_id"] ?? '',
        plannedHrs: json["planned_hrs"] ?? 0,
        taskName: json["task_name"] ?? '',
        taskDescription: json["task_description"] ?? '',
        id: json["id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "planned_hrs": plannedHrs,
        "task_name": taskName,
        "task_description": taskDescription,
        "id": id,
      };
}
