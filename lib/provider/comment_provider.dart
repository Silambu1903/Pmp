import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/projectcommentmodel.dart';
import '../service/apiService.dart';
import '../state/dailytaskstate.dart';


final getCommentListNotifier =
FutureProvider.family<List<ProjectManagementProcessProjectComment>, String>(
        (ref, id) async {
      return await ref.read(apiProvider).getCommentsData(id);
    });
final insertCommentNotifier =
    StateNotifierProvider<InsertCommentProvider, DailyTaskSate>((ref) {
  return InsertCommentProvider(ref);
});

class InsertCommentProvider extends StateNotifier<DailyTaskSate> {
  Ref ref;

  InsertCommentProvider(this.ref)
      : super(DailyTaskSate(false, const AsyncLoading(), ''));

  insertCommentData(var projectId, var userId, String comment) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).insertComment(projectId,userId,comment);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  DailyTaskSate _dataState(String entity) {
    return DailyTaskSate(false, AsyncData(entity), '');
  }

  DailyTaskSate _loading() {
    return DailyTaskSate(true, state.id, '');
  }

  DailyTaskSate _errorState(int statusCode, String errMsg) {
    return DailyTaskSate(
        false, state.id, 'response code $statusCode  msg $errMsg');
  }
}
