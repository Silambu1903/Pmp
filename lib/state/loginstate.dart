import 'package:riverpod/riverpod.dart';

import '../model/login_model.dart';

class LoginSate {
  bool isLoading;
  AsyncValue<List<ProjectManagementProcessUserRegistration>> projectManagementProcessUserRegistration;
  String error;

  LoginSate(this.isLoading,this.projectManagementProcessUserRegistration, this.error);


}