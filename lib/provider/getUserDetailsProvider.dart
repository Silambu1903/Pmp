import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/login_model.dart';
import 'package:pmp/service/apiService.dart';

final getUserDetailsProvider = StateNotifierProvider<GetUserDetailsProvider, List<ProjectManagementProcessUserRegistration>>(
        (ref) => GetUserDetailsProvider(ref));

class GetUserDetailsProvider
    extends StateNotifier<List<ProjectManagementProcessUserRegistration>> {
  final Ref ref;

  GetUserDetailsProvider(this.ref) : super([]);

  fetchUser(String employeeCode) async {
    try {
      List<ProjectManagementProcessUserRegistration> userList =
      await ref.read(apiProvider).getUser(employeeCode: employeeCode);
      state = userList;
    } catch (e) {
      print(e);
    }
  }
}
