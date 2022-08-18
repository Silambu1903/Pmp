import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper.dart';
import '../../model/login_model.dart';
import '../../service/apiService.dart';
import '../../state/adduserstate.dart';


final updateUserNotifier =
StateNotifierProvider<UpdateUserProvider, AddUserSate>((ref) {
  return UpdateUserProvider(ref);
});

class UpdateUserProvider extends StateNotifier<AddUserSate> {
  Ref ref;

  UpdateUserProvider(this.ref)
      : super(AddUserSate(false, const AsyncLoading(), 'initial'));

  updateUser(
      ProjectManagementProcessUserRegistration
      projectManagementProcessUserRegistration) async {
    state = _loading();
    final data = await ref.read(apiProvider).updateUser(projectManagementProcessUserRegistration);
    if (data != null) {
      state = _dataState(data);
    } else if (data == null) {
      state = _errorState('Update Failed');
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