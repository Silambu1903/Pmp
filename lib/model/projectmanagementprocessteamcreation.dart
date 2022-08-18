class ProjectManagementProcessTeamCreationReport {
  ProjectManagementProcessTeamCreationReport({
    this.id,
    this.teamName,
    this.dailyReportsAggregate,
    this.dailyReports,
  });

  String? id;
  String? teamName;
  DailyReportsAggregate? dailyReportsAggregate;
  List<DailyReport>? dailyReports;

  factory ProjectManagementProcessTeamCreationReport.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessTeamCreationReport(
        id: json["id"]??'',
        teamName: json["team_name"]??'',
        dailyReportsAggregate:
            DailyReportsAggregate.fromJson(json["daily_reports_aggregate"]),
        dailyReports: List<DailyReport>.from(
            json["daily_reports"].map((x) => DailyReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_name": teamName,
        "daily_reports_aggregate": dailyReportsAggregate!.toJson(),
        "daily_reports":
            List<dynamic>.from(dailyReports!.map((x) => x.toJson())),
      };
}

class DepartmentCreation {
  DepartmentCreation({
    this.group,
  });

  String? group;

  factory DepartmentCreation.fromJson(Map<String, dynamic> json) =>
      DepartmentCreation(
        group: json["group"],
      );

  Map<String, dynamic> toJson() => {
        "group": group.toString(),
      };
}

class DailyReport {
  DailyReport(
      {this.createdDate,
      this.spentHrs,
      this.remarks,
      this.taskDetails,
      this.userRegistration,
      this.projectCreation,
      this.departmentCreation});

  dynamic createdDate;
  dynamic spentHrs;
  String? remarks;
  String? taskDetails;
  UserRegistration? userRegistration;
  ProjectCreation? projectCreation;
  DepartmentCreation? departmentCreation;

  factory DailyReport.fromJson(Map<String, dynamic> json) => DailyReport(
        createdDate: json["created_date"]??'',
        spentHrs: json["spent_hrs"].toDouble(),
        remarks: json["remarks"]??'',
        taskDetails: json["task_details"]??'',
        userRegistration: UserRegistration.fromJson(json["user_registration"]),
        projectCreation: ProjectCreation.fromJson(json["project_creation"]),
        departmentCreation:
            DepartmentCreation.fromJson(json["department_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "created_date": createdDate,
        "spent_hrs": spentHrs,
        "remarks": remarks,
        "task_details": taskDetails,
        "user_registration": userRegistration!.toJson(),
        "project_creation": projectCreation!.toJson(),
        "department_creation": departmentCreation!.toJson(),
      };
}

class ProjectCreation {
  ProjectCreation({
    this.projectCode,
    this.projectName,
    this.project_weightage,
  });

  String? projectCode;
  String? projectName;
  var project_weightage;

  factory ProjectCreation.fromJson(Map<String, dynamic> json) =>
      ProjectCreation(
        projectCode: json["project_code"]??'',
        projectName: json["project_name"]??'',
        project_weightage: json["project_weightage"]??0,
      );

  Map<String, dynamic> toJson() => {
        "project_code": projectCode,
        "project_name": projectName,
        "project_weightage": project_weightage,
      };
}

class UserRegistration {
  UserRegistration({
    this.userName,
    this.employeCode,
    this.avatar,
  });

  String? userName;
  String? employeCode;
  String? avatar;

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      UserRegistration(
        userName: json["user_name"],
        employeCode: json["employe_code"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "employe_code": employeCode,
        "avatar": avatar,
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
        sum: json["sum"] == null ? Sum(spentHrs: 0) : Sum.fromJson(json["sum"]),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum!.toJson(),
      };
}

class Sum {
  Sum({
    this.spentHrs,
  });

  dynamic spentHrs;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
        spentHrs: json["spent_hrs"] == null ? 0 : json["spent_hrs"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "spent_hrs": spentHrs ?? '',
      };
}
