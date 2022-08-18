
class ProjectReportList {
  ProjectReportList({
    this.projectCode,
    this.projectName,
    this.createDate,
    this.deliveryDate,
    this.plannedHrs,
    this.allocationProjects,
    this.dailyReports,
    this.status,
    this.dailyReportsAggregate,
  });

  String? projectCode;
  String? projectName;
  dynamic createDate;
  String? deliveryDate;
  dynamic plannedHrs;
  String? status;
  List<AllocationProjectReport>? allocationProjects;
  List<DailyProjectReport>? dailyReports;
  DailyReportsAggregate? dailyReportsAggregate;

  factory ProjectReportList.fromJson(Map<String, dynamic> json) => ProjectReportList(
    projectCode: json["project_code"],
    projectName: json["project_name"],
    createDate: json["create_date"],
    deliveryDate: json["delivery_date"],
    status: json["status"],
    plannedHrs: json["planned_hrs"],
    allocationProjects: List<AllocationProjectReport>.from(json["allocation_projects"].map((x) => AllocationProjectReport.fromJson(x))),
    dailyReports: List<DailyProjectReport>.from(json["daily_reports"].map((x) => DailyProjectReport.fromJson(x))),
    dailyReportsAggregate: DailyReportsAggregate.fromJson(json["daily_reports_aggregate"]),
  );

  Map<String, dynamic> toJson() => {
    "project_code": projectCode,
    "project_name": projectName,
    "create_date": "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
    "delivery_date": deliveryDate,
    "planned_hrs": plannedHrs,
    "status": status,
    "allocation_projects": List<dynamic>.from(allocationProjects!.map((x) => x.toJson())),
    "daily_reports": List<dynamic>.from(dailyReports!.map((x) => x.toJson())),
    "daily_reports_aggregate": dailyReportsAggregate!.toJson(),
  };
}

class AllocationProjectReport {
  AllocationProjectReport({
    this.plannedHrs,
    this.teamCreation,
  });

  String ?plannedHrs;
  TeamCreation ?teamCreation;

  factory AllocationProjectReport.fromJson(Map<String, dynamic> json) => AllocationProjectReport(
    plannedHrs: json["planned_hrs"],
    teamCreation: TeamCreation.fromJson(json["team_creation"]),
  );

  Map<String, dynamic> toJson() => {
    "planned_hrs": plannedHrs,
    "team_creation": teamCreation!.toJson(),
  };
}

class TeamCreation {
  TeamCreation({
    this.teamName,
  });

  String ? teamName;

  factory TeamCreation.fromJson(Map<String, dynamic> json) => TeamCreation(
    teamName: json["team_name"],
  );

  Map<String, dynamic> toJson() => {
    "team_name": teamName,
  };
}


class DailyProjectReport {
  DailyProjectReport({
    this.spentHrs,
    this.teamCreation,
  });

  dynamic spentHrs;
  TeamCreation ? teamCreation;

  factory DailyProjectReport.fromJson(Map<String, dynamic> json) => DailyProjectReport(
    spentHrs: json["spent_hrs"].toDouble(),
    teamCreation: json["team_creation"] == null ? null : TeamCreation.fromJson(json["team_creation"]),
  );

  Map<String, dynamic> toJson() => {
    "spent_hrs": spentHrs,
    "team_creation": teamCreation == null ? null : teamCreation!.toJson(),
  };
}

class DailyReportsAggregate {
  DailyReportsAggregate({
    this.aggregate,
  });

  Aggregate ?aggregate;

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

  dynamic sum;

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

  dynamic? spentHrs;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
    spentHrs: json["spent_hrs"] == null ? '' : json["spent_hrs"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "spent_hrs": spentHrs ?? '',
  };
}

