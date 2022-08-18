class ProjectManagementProcessDepartmentCreation {
  ProjectManagementProcessDepartmentCreation({
    this.group,
    this.id,
    this.isActive,
  });

  String? group;
  String? id;
  bool? isActive;

  factory ProjectManagementProcessDepartmentCreation.fromJson(
          Map<String, dynamic> json) =>
      ProjectManagementProcessDepartmentCreation(
        group: json["group"],
        id: json["id"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "group": group,
        "id": id,
        "is_active": isActive,
      };
}
