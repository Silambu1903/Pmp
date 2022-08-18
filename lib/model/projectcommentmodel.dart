class ProjectManagementProcessProjectComment {
  ProjectManagementProcessProjectComment({
    this.userId,
    this.projectId,
    this.date,
    this.comment,
    this.userRegistration,
  });

  String ?userId;
  String ?projectId;
  String ?date;
  String ?comment;
  UserRegistration? userRegistration;

  factory ProjectManagementProcessProjectComment.fromJson(Map<String, dynamic> json) => ProjectManagementProcessProjectComment(
    userId: json["user_id"],
    projectId: json["project_id"],
    date: json["date"],
    comment: json["comment"],
    userRegistration: UserRegistration.fromJson(json["user_registration"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "project_id": projectId,
    "date": date,
    "comment": comment,
    "user_registration": userRegistration!.toJson(),
  };
}

class UserRegistration {
  UserRegistration({
    this.userName,
    this.avatar,
  });

  String? userName;
  String ?avatar;

  factory UserRegistration.fromJson(Map<String, dynamic> json) => UserRegistration(
    userName: json["user_name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "avatar": avatar,
  };
}
