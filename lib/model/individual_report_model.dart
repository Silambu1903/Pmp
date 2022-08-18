import 'package:pmp/model/projectmanagementdailyreport.dart';
import 'package:pmp/model/projectmanagementprocessteamcreation.dart';



class ProjectManagementProcessDailyReportAggregate {
  ProjectManagementProcessDailyReportAggregate({
    this.aggregate,
  });

  Aggregate ? aggregate;

  factory ProjectManagementProcessDailyReportAggregate.fromJson(Map<String, dynamic> json) => ProjectManagementProcessDailyReportAggregate(
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

  double? spentHrs;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
    spentHrs: json["spent_hrs"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "spent_hrs": spentHrs,
  };
}


class IndividualReportProjectManagementProcessDailyReport {
  IndividualReportProjectManagementProcessDailyReport({
    this.userRegistration,
    this.departmentId,
    this.remarks,
    this.spentHrs,
    this.taskDetails,
    this.createdDate,
    this.projectCreation,
  });

  UserRegistration ?userRegistration;
  String? departmentId;
  String ?remarks;
  double ?spentHrs;
  String ?taskDetails;
  dynamic createdDate;
  ProjectCreation ?projectCreation;

  factory IndividualReportProjectManagementProcessDailyReport.fromJson(Map<String, dynamic> json) => IndividualReportProjectManagementProcessDailyReport(
    userRegistration: UserRegistration.fromJson(json["user_registration"]),
    departmentId: json["department_id"],
    remarks: json["remarks"],
    spentHrs: json["spent_hrs"].toDouble(),
    taskDetails: json["task_details"],
    createdDate: json["created_date"],
    projectCreation: ProjectCreation.fromJson(json["project_creation"]),
  );

  Map<String, dynamic> toJson() => {
    "user_registration": userRegistration!.toJson(),
    "department_id": departmentId,
    "remarks": remarks,
    "spent_hrs": spentHrs,
    "task_details": taskDetails,
    "created_date": "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
    "project_creation": projectCreation!.toJson(),
  };
}

class IndividualReportProjectProjectCreation {
  IndividualReportProjectProjectCreation({
    this.projectName,
  });

  String? projectName;

  factory IndividualReportProjectProjectCreation.fromJson(Map<String, dynamic> json) => IndividualReportProjectProjectCreation(
    projectName: json["project_name"],
  );

  Map<String, dynamic> toJson() => {
    "project_name":projectName,
  };
}



