class QPIProjectCalculationProjectById {
  QPIProjectCalculationProjectById({
    this.id,
    this.projectWeightage,
    this.projectName,
    this.projectAssigns,
  });

  String? id;
  int? projectWeightage;
  String? projectName;
  List<ProjectAssign>? projectAssigns;

  factory QPIProjectCalculationProjectById.fromJson(
          Map<String, dynamic> json) =>
      QPIProjectCalculationProjectById(
        id: json["id"],
        projectWeightage: json["project_weightage"],
        projectName: json["project_name"],
        projectAssigns: List<ProjectAssign>.from(
            json["project_assigns"].map((x) => ProjectAssign.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_weightage": projectWeightage,
        "project_name": projectName,
        "project_assigns":
            List<dynamic>.from(projectAssigns!.map((x) => x.toJson())),
      };
}

class ProjectAssign {
  ProjectAssign({
    this.id,
    this.userRegistration,
    this.dailyReportsAggregate,
    this.taskAssignsAggregate,
  });

  String? id;
  UserRegistration? userRegistration;
  DailyReportsAggregate? dailyReportsAggregate;
  TaskAssignsAggregate? taskAssignsAggregate;

  factory ProjectAssign.fromJson(Map<String, dynamic> json) => ProjectAssign(
        id: json["id"],
        userRegistration: UserRegistration.fromJson(json["user_registration"]),
        dailyReportsAggregate:
            DailyReportsAggregate.fromJson(json["daily_reports_aggregate"]),
        taskAssignsAggregate:
            TaskAssignsAggregate.fromJson(json["task_assigns_aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_registration": userRegistration!.toJson(),
        "daily_reports_aggregate": dailyReportsAggregate!.toJson(),
        "task_assigns_aggregate": taskAssignsAggregate!.toJson(),
      };
}

class DailyReportsAggregate {
  DailyReportsAggregate({
    this.aggregate,
  });

  Aggregate? aggregate;

  factory DailyReportsAggregate.fromJson(Map<String, dynamic> json) =>
      DailyReportsAggregate(
        aggregate: Aggregate.fromJson(json["aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate!.toJson(),
      };
}

class Aggregate {
  Aggregate({
    this.sum,
  });

  Sum? sum;

  factory Aggregate.fromJson(Map<String, dynamic> json) => Aggregate(
        sum: Sum.fromJson(json["sum"]),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum!.toJson(),
      };
}

class Sum {
  Sum({
    this.spentHrs,
  });

  var spentHrs;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
        spentHrs: json["spent_hrs"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "spent_hrs": spentHrs ?? 0,
      };
}

class UserRegistration {
  UserRegistration({
    this.id,
    this.userName,
    this.teamId,
    this.depId
  });

  String? id;
  String? userName;
  String? teamId;
  String? depId;

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      UserRegistration(
        id: json["id"],
        userName: json["user_name"],
        teamId: json["team_id"],
        depId: json["department_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "team_id": teamId,
        "department_id": depId,
      };
}

class TaskAssignsAggregate {
  TaskAssignsAggregate({
    this.aggregate,
  });

  TaskAssignsAggregateAggregate? aggregate;

  factory TaskAssignsAggregate.fromJson(Map<String, dynamic> json) =>
      TaskAssignsAggregate(
        aggregate: TaskAssignsAggregateAggregate.fromJson(json["aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate!.toJson(),
      };
}

class TaskAssignsAggregateAggregate {
  TaskAssignsAggregateAggregate({
    this.sum,
  });

  FluffySum? sum;

  factory TaskAssignsAggregateAggregate.fromJson(Map<String, dynamic> json) =>
      TaskAssignsAggregateAggregate(
        sum: FluffySum.fromJson(json["sum"]),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum!.toJson(),
      };
}

class FluffySum {
  FluffySum({
    this.taskAssignHrs,
  });

  int? taskAssignHrs;

  factory FluffySum.fromJson(Map<String, dynamic> json) => FluffySum(
        taskAssignHrs: json["task_assign_hrs"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "task_assign_hrs": taskAssignHrs ?? 0,
      };
}
