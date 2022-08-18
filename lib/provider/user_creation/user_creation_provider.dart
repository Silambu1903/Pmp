import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper.dart';
import '../../model/login_model.dart';
import '../../service/apiService.dart';
import '../../state/adduserstate.dart';

final getCurrentUser =
    FutureProvider<List<ProjectManagementProcessUserRegistration>>((ref) async {
  return await ref.read(apiProvider).getUser(
      employeeCode: Helper.sharedEmployeeCode!,
      password: Helper.sharedpassword!);
});

final addUserNotifier =
    StateNotifierProvider<AddUserProvider, AddUserSate>((ref) {
  return AddUserProvider(ref);
});

class AddUserProvider extends StateNotifier<AddUserSate> {
  Ref ref;

  AddUserProvider(this.ref)
      : super(AddUserSate(false, const AsyncLoading(), 'initial'));

  addUser(
      ProjectManagementProcessUserRegistration
          projectManagementProcessUserRegistration) async {
    state = _loading();
    final data = await ref
        .read(apiProvider)
        .createUser(projectManagementProcessUserRegistration);
    if (data != null) {
      state = _dataState(data);
    } else if (data == null) {
      state = _errorState('EmployeeId Exists');
    }
    return state;
  }

  AddUserSate _dataState(String entity) {
    return AddUserSate(false, AsyncData(entity), '');
  }

  AddUserSate _loading() {
    return AddUserSate(true, state.id, '');
  }

  AddUserSate _errorState(String errMsg) {
    return AddUserSate(false, state.id, errMsg);
  }
}
