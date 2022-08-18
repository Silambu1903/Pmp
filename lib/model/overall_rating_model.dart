class OverAllRatingModel {
  OverAllRatingModel({
    this.projectManagementProcessUserRegistration,
    this.dpiTotal,
    this.dpiCount,
    this.spiTotal,
    this.spiCount,
    this.qpiTotal,
    this.qpiCount,
    this.priTotal,
    this.priCount,
  });

  List<ProjectManagementProcessUserRegistrationOverAll>?
      projectManagementProcessUserRegistration;
  var dpiTotal, dpiCount;
  var spiTotal, spiCount;
  var qpiTotal, qpiCount;
  var priTotal, priCount;
}

class PurpleSum {
  PurpleSum({
    this.rating,
  });

  dynamic rating;

  factory PurpleSum.fromJson(Map<String, dynamic> json) => PurpleSum(
        rating: json["rating"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
      };
}

class FluffySum {
  FluffySum({
    this.ratingValue,
  });

  dynamic ratingValue;

  factory FluffySum.fromJson(Map<String, dynamic> json) => FluffySum(
        ratingValue: json["rating_value"],
      );

  Map<String, dynamic> toJson() => {
        "rating_value": ratingValue,
      };
}

class ProjectManagementProcessUserRegistrationOverAll {
  ProjectManagementProcessUserRegistrationOverAll({
    this.userName,
    this.employeCode,
    this.type,
    this.dpiTotal,
    this.spiTotal,
    this.qpiTotal,
    this.priTotal,
  });

  String? userName;
  String? employeCode;
  String? type;
  var dpiTotal, spiTotal, qpiTotal, priTotal;

  factory ProjectManagementProcessUserRegistrationOverAll.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessUserRegistrationOverAll(
        userName: json["user_name"] ?? '',
        employeCode: json["employe_code"] ?? '',
        type: json["type"],
        dpiTotal: json["daily_performance_indices_aggregate"]["aggregate"]["sum"]['rating'] ?? 0,
        priTotal: json["productivity_indices_aggregate"]["aggregate"]["sum"]['rating'] ?? 0,
        qpiTotal:json["quality_performance_indices_aggregate"]["aggregate"]["sum"]['rating_value'] ?? 0,
        spiTotal: json["supervisors_performance_indices_aggregate"]["aggregate"]["sum"]['rating'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "employe_code": employeCode,
        "type": type,
        "daily_performance_indices_aggregate": dpiTotal,
        "productivity_indices_aggregate": spiTotal,
        "quality_performance_indices_aggregate": qpiTotal,
        "supervisors_performance_indices_aggregate": priTotal,
      };
}

class IndicesAggregate {
  IndicesAggregate({
    this.aggregate,
  });

  DailyPerformanceIndicesAggregateAggregate? aggregate;

  factory IndicesAggregate.fromJson(Map<String, dynamic> json) =>
      IndicesAggregate(
        aggregate: DailyPerformanceIndicesAggregateAggregate.fromJson(
            json["aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate!.toJson(),
      };
}

class DailyPerformanceIndicesAggregateAggregate {
  DailyPerformanceIndicesAggregateAggregate({
    this.sum,
  });

  PurpleSum? sum;

  factory DailyPerformanceIndicesAggregateAggregate.fromJson(
          Map<String, dynamic> json) =>
      DailyPerformanceIndicesAggregateAggregate(
        sum: PurpleSum.fromJson(json["sum"]),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum!.toJson(),
      };
}

class QualityPerformanceIndicesAggregate {
  QualityPerformanceIndicesAggregate({
    this.aggregate,
  });

  QualityPerformanceIndicesAggregateAggregate? aggregate;

  factory QualityPerformanceIndicesAggregate.fromJson(
          Map<String, dynamic> json) =>
      QualityPerformanceIndicesAggregate(
        aggregate: QualityPerformanceIndicesAggregateAggregate.fromJson(
            json["aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate!.toJson(),
      };
}

class QualityPerformanceIndicesAggregateAggregate {
  QualityPerformanceIndicesAggregateAggregate({
    this.sum,
  });

  FluffySum? sum;

  factory QualityPerformanceIndicesAggregateAggregate.fromJson(
          Map<String, dynamic> json) =>
      QualityPerformanceIndicesAggregateAggregate(
        sum: FluffySum.fromJson(json["sum"]),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum!.toJson(),
      };
}
