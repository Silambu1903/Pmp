import 'package:pmp/model/login_model.dart';

class Welcome {

  Welcome({this.data});
  ProjectManagementMultipleItem? data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    data: ProjectManagementMultipleItem.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };


}

class ProjectManagementMultipleItem {
  ProjectManagementMultipleItem({
    this.item1,
    this.item2,
  });

  List<ProjectManagementProcessUserRegistration> ? item1;
  List<ProjectManagementProcessUserRegistration> ? item2;

  factory ProjectManagementMultipleItem.fromJson(Map<String, dynamic> json) => ProjectManagementMultipleItem(
    item1: List<ProjectManagementProcessUserRegistration>.from(json["item1"].map((x) => ProjectManagementMultipleItem.fromJson(x))),
    item2: List<ProjectManagementProcessUserRegistration>.from(json["item2"].map((x) => ProjectManagementMultipleItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "item1": List<dynamic>.from(item1!.map((x) => x.toJson())),
    "item2": List<dynamic>.from(item2!.map((x) => x.toJson())),
  };
}



