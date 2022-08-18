import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/projectmanagementdailyreport.dart';
import 'package:pmp/model/projectmanagementprocessallocationproject.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/service/apiService.dart';

import '../../model/dpi_rating_list_model.dart';
import '../../model/individual_report_model.dart';
import '../../state/dailytaskstate.dart';
import '../../state/projectallocationsate.dart';


final individualReportNotifier =
FutureProvider.family<List<IndividualReportProjectManagementProcessDailyReport>,List<String>>((ref,id) async {
  return await ref.read(apiProvider).getIndividualReportTeam(id);
});


final dailyTaskListNotifier =
    FutureProvider.family<List<ProjectManagementProcessDailyReport>, String>(
        (ref, id) async {
  return await ref.read(apiProvider).getDailyReportDetails(id);
});

final dpiRatingListNotifier =
FutureProvider.family<List<DpiRatingDailyReport>, List<String>>(
        (ref, id) async {
      return await ref.read(apiProvider).getDpiRatingList(id);
    });

final dailyTaskListManagerNotifier =
FutureProvider.family<List<ProjectManagementProcessDailyReport>, String>(
        (ref, id) async {
      return await ref.read(apiProvider).getDailyReportManagerDetails(id);
    });

final dailyTaskNotifier =
    StateNotifierProvider<DailyTaskProvider, DailyTaskSate>((ref) {
  return DailyTaskProvider(ref);
});

class DailyTaskProvider extends StateNotifier<DailyTaskSate> {
  Ref ref;

  DailyTaskProvider(this.ref)
      : super(DailyTaskSate(false, const AsyncLoading(), ''));

  dailyTask(ProjectManagementProcessDailyReport processDailyReport, var assignId) async {
    state = _loading();
    final data =
        await ref.read(apiProvider).dailyTaskUpdated(processDailyReport,assignId);
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
