import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/individual_report_model.dart';
import '../../model/login_model.dart';
import '../../model/projectmanagementmutipleitem.dart';
import '../../service/apiService.dart';


final userListStateProvider =
FutureProvider<List<ProjectManagementProcessUserRegistration>>((ref) async {
  return await ref.read(apiProvider).getUserList();
});

final userListTeamStateProvider =
FutureProvider<List<ProjectManagementProcessUserRegistration>>((ref) async {
  return await ref.read(apiProvider).getUserListTeam();
});


final userFilterListTeamWiseStateProvider =
FutureProvider.family<List<ProjectManagementProcessUserRegistration>,String>((ref,id) async {
  return await ref.read(apiProvider).getUserFilterListTeam(id);
});



