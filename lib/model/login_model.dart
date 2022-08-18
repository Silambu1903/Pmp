import 'package:pmp/model/project_assign_user.dart';

import '../provider/project_allocation_provider/project_report_team_lead.dart';

class ProjectManagementProcessUserRegistration {
  ProjectManagementProcessUserRegistration({this.userName,
    this.type,
    this.password,
    this.mobileNo,
    this.isActive,
    this.id,
    this.employeCode,
    this.email,
    this.departmentId,
    this.createdId,
    this.createdDate,
    this.avatar,
    this.teamId,
    this.dailyReportsAggregate});

  String? userName;
  String? type;
  String? password;
  String? mobileNo;
  bool? isActive;
  var id;
  String? employeCode;
  String? email;
  var departmentId;
  var teamId;
  var createdId;
  String? createdDate;
  dynamic avatar;


  DailyReportsAggregate? dailyReportsAggregate;

  factory ProjectManagementProcessUserRegistration.fromJson(
      Map<String, dynamic> json) =>
      ProjectManagementProcessUserRegistration(
        userName: json["user_name"],
        type: json["type"],
        password: json["password"],
        mobileNo: json["mobile_no"],
        isActive: json["is_active"],
        id: json["id"],
        employeCode: json["employe_code"],
        email: json["email"],
        departmentId: json["department_id"],
        createdId: json["created_id"],
        createdDate: json["created_date"],
        avatar: json["avatar"],
        teamId: json["team_id"],
        dailyReportsAggregate: json["daily_reports_aggregate"] != null
            ? DailyReportsAggregate.fromJson(json["daily_reports_aggregate"])
            : null,
      );

  Map<String, dynamic> toJson() =>
      {
        "user_name": userName,
        "type": type,
        "password": password,
        "mobile_no": mobileNo,
        "is_active": isActive,
        "id": id,
        "employe_code": employeCode,
        "email": email,
        "department_id": departmentId,
        "created_id": createdId,
        "created_date": createdDate,
        "avatar": avatar,
        "team_id": teamId
      };
}
