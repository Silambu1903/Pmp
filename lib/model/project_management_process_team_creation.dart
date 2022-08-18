class ProjectManagementProcessTeamCreation {
  ProjectManagementProcessTeamCreation({
    this.teamName,
    this.id,
    this.departmentId,
    this.icon,
    this.plannedHr
  });

  String? teamName = '';
  var id;
  var departmentId;
  String? icon = '';
  String? plannedHr = '';

  factory ProjectManagementProcessTeamCreation.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessTeamCreation(
        teamName: json["team_name"],
        id: json["id"],
        departmentId: json["department_id"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "team_name": teamName,
        "id": id,
        "department_id": departmentId,
        "icon": icon,
      };
}
