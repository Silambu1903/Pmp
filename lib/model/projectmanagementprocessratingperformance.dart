class Data {
  Data({
    this.item1,
    this.item2,
  });

  Item1? item1;
  List<ProjectManagementProcessRatingPerformance>? item2;


}

class Item1 {
  Item1({
    this.aggregate,
  });

  Aggregate? aggregate;

  factory Item1.fromJson(Map<String, dynamic> json) => Item1(
      aggregate: json["aggregate"] != null
          ? Aggregate.fromJson(json["aggregate"])
          : Aggregate());

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate!.toJson(),
      };
}

class Aggregate {
  Aggregate({
    this.avg,
  });

  Avg? avg;

  factory Aggregate.fromJson(Map<String, dynamic> json) => Aggregate(
        avg: Avg.fromJson(json["avg"]),
      );

  Map<String, dynamic> toJson() => {
        "avg": avg!.toJson(),
      };
}

class Avg {
  Avg({
    this.attitude,
    this.onTimeDelivery,
    this.punctuality,
    this.qualityOfWork,
    this.smartness,
    this.totalRatingValue,
    this.workstationNeatness,
  });

  dynamic attitude;
  dynamic onTimeDelivery;
  dynamic punctuality;
  dynamic qualityOfWork;
  dynamic smartness;
  dynamic totalRatingValue;
  dynamic workstationNeatness;

  factory Avg.fromJson(Map<String, dynamic> json) => Avg(
        attitude: json["attitude"].toDouble(),
        onTimeDelivery: json["on_time_delivery"].toDouble(),
        punctuality: json["punctuality"].toDouble(),
        qualityOfWork: json["quality_of_work"],
        smartness: json["smartness"],
        totalRatingValue: json["total_rating_value"].toDouble(),
        workstationNeatness: json["workstation_neatness"],
      );

  Map<String, dynamic> toJson() => {
        "attitude": attitude,
        "on_time_delivery": onTimeDelivery,
        "punctuality": punctuality,
        "quality_of_work": qualityOfWork,
        "smartness": smartness,
        "total_rating_value": totalRatingValue,
        "workstation_neatness": workstationNeatness,
      };
}

class ProjectManagementProcessRatingPerformance {
  ProjectManagementProcessRatingPerformance({
    this.id,
    this.date,
    this.departmentId,
    this.attitude,
    this.onTimeDelivery,
    this.punctuality,
    this.qualityOfWork,
    this.ratedBy,
    this.smartness,
    this.workstationNeatness,
    this.totalRatingValue,
    this.userId,
    this.teamId,
    this.userRegistrationByRatedBy,
    this.userRegistration,
    this.teamCreation,
  });

  dynamic id;
  dynamic date;
  dynamic departmentId;
  dynamic attitude;
  dynamic onTimeDelivery;
  dynamic punctuality;
  dynamic qualityOfWork;
  dynamic ratedBy;
  dynamic smartness;
  dynamic workstationNeatness;
  dynamic totalRatingValue;
  dynamic userId;
  dynamic teamId;
  UserRegistration? userRegistrationByRatedBy;
  UserRegistration? userRegistration;
  TeamCreation? teamCreation;

  factory ProjectManagementProcessRatingPerformance.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessRatingPerformance(
        id: json["id"],
        date: json["date"],
        departmentId: json["department_id"],
        attitude: json["attitude"],
        onTimeDelivery: json["on_time_delivery"],
        punctuality: json["punctuality"],
        qualityOfWork: json["quality_of_work"],
        ratedBy: json["rated_by"],
        smartness: json["smartness"],
        workstationNeatness: json["workstation_neatness"],
        totalRatingValue: json["total_rating_value"].toDouble(),
        userId: json["user_id"],
        teamId: json["team_id"],
        userRegistrationByRatedBy:
            UserRegistration.fromJson(json["userRegistrationByUserId"]),
        userRegistration: UserRegistration.fromJson(json["user_registration"]),
        teamCreation: json["team_creation"] != null
            ? TeamCreation.fromJson(json["team_creation"])
            : TeamCreation(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "department_id": departmentId,
        "attitude": attitude,
        "on_time_delivery": onTimeDelivery,
        "punctuality": punctuality,
        "quality_of_work": qualityOfWork,
        "rated_by": ratedBy,
        "smartness": smartness,
        "workstation_neatness": workstationNeatness,
        "total_rating_value": totalRatingValue,
        "user_id": userId,
        "team_id": teamId,
        "userRegistrationByUserId": userRegistrationByRatedBy!.toJson(),
        "user_registration": userRegistration!.toJson(),
        "team_creation": teamCreation!.toJson(),
      };
}

class TeamCreation {
  TeamCreation({
    this.teamName,
  });

  String? teamName;

  factory TeamCreation.fromJson(Map<String, dynamic> json) => TeamCreation(
        teamName: json["team_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "team_name": teamName,
      };
}

class UserRegistration {
  UserRegistration({
    this.userName,
  });

  String? userName;

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      UserRegistration(
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
      };
}
