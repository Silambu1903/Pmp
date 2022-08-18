import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/login_model.dart';
import 'package:pmp/service/apiService.dart';

import '../state/loginstate.dart';

final loginNotifier = StateNotifierProvider<LoginProvider, LoginSate>((ref) {
  return LoginProvider(ref);
});

class LoginProvider extends StateNotifier<LoginSate> {
  Ref ref;

  LoginProvider(this.ref)
      : super(LoginSate(false,  const AsyncLoading(), 'initial'));

  fetchUser(String employeeCode,String password) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).getUser(employeeCode: employeeCode,password: password);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  LoginSate _dataState(List<ProjectManagementProcessUserRegistration> entity) {
    return LoginSate(false,  AsyncData(entity), '');
  }

  LoginSate _loading() {
    return LoginSate(
        true,  state.projectManagementProcessUserRegistration, '');
  }

  LoginSate _errorState(int statusCode, String errMsg) {
    return LoginSate(false, state.projectManagementProcessUserRegistration,
        'response code $statusCode  msg $errMsg');
  }
}
