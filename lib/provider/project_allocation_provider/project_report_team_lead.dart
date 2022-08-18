class ProjectReportTeamLead {
  ProjectReportTeamLead({
    this.projectCreation,
  });

 ProjectCreationTeamLeadReport ? projectCreation;

  factory ProjectReportTeamLead.fromJson(Map<String, dynamic> json) => ProjectReportTeamLead(
    projectCreation: ProjectCreationTeamLeadReport.fromJson(json["project_creation"]),
  );

  Map<String, dynamic> toJson() => {
    "project_creation": projectCreation!.toJson(),
  };
}

class ProjectCreationTeamLeadReport {
  ProjectCreationTeamLeadReport({
    this.projectCode,
    this.projectName,
    this.createDate,
    this.deliveryDate,
    this.plannedHrs,
    this.status,
    this.dailyReports,
    this.dailyReportsAggregate,
  });

  String ?projectCode;
  String ? projectName;
  dynamic createDate;
  String? deliveryDate;
  dynamic plannedHrs;
  String? status;
  List<DailyReportTeamLead> ? dailyReports;
  DailyReportsAggregate? dailyReportsAggregate;

  factory ProjectCreationTeamLeadReport.fromJson(Map<String, dynamic> json) => ProjectCreationTeamLeadReport(
    projectCode: json["project_code"],
    projectName: json["project_name"],
    createDate: json["create_date"],
    deliveryDate: json["delivery_date"],
    plannedHrs: json["planned_hrs"],
    status: json["status"],
    dailyReports: List<DailyReportTeamLead>.from(json["daily_reports"].map((x) => DailyReportTeamLead.fromJson(x))),
    dailyReportsAggregate: DailyReportsAggregate.fromJson(json["daily_reports_aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "project_code": projectCode,
    "project_name": projectName,
    "create_date": "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
    "delivery_date": deliveryDate,
    "planned_hrs": plannedHrs,
    "status": status,
    "daily_reports": List<dynamic>.from(dailyReports!.map((x) => x.toJson())),
    "daily_reports_aggregate": dailyReportsAggregate!.toJson(),
  };
}

class DailyReportTeamLead {
  DailyReportTeamLead({
    this.spentHrs,
    this.userRegistration,
  });

  dynamic spentHrs;
  UserRegistration  ? userRegistration;

  factory DailyReportTeamLead.fromJson(Map<String, dynamic> json) => DailyReportTeamLead(
    spentHrs: json["spent_hrs"]!=null ? json["spent_hrs"].toDouble():0.0,
    userRegistration: UserRegistration.fromJson(json["user_registration"]),
  );

  Map<String, dynamic> toJson() => {
    "spent_hrs": spentHrs,
    "user_registration": userRegistration!.toJson(),
  };
}

class UserRegistration {
  UserRegistration({
    this.userName,
  });

  String ? userName;

  factory UserRegistration.fromJson(Map<String, dynamic> json) => UserRegistration(
    userName: json["user_name"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
  };
}


class DailyReportsAggregate {
  DailyReportsAggregate({
    this.aggregate,
  });

  Aggregate ? aggregate;

  factory DailyReportsAggregate.fromJson(Map<String, dynamic> json) => DailyReportsAggregate(
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

  Sum ? sum;

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

  dynamic  spentHrs;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
    spentHrs: json["spent_hrs"]!=null ? json["spent_hrs"].toDouble():0.0, 
  );

  Map<String, dynamic> toJson() => {
    "spent_hrs": spentHrs,
  };
}

