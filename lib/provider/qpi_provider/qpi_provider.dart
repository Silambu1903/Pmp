import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/qpi_project_calculation_project_by_id.dart';
import '../../service/apiService.dart';
import '../../state/qpiProjectCaluculationState.dart';


final qpiCalculationNotifier =
StateNotifierProvider<QpiCalculationProvider, QpiProjectCalculationState>((ref) {
  return QpiCalculationProvider(ref);
});


class QpiCalculationProvider extends StateNotifier<QpiProjectCalculationState> {
  Ref ref;

  QpiCalculationProvider(this.ref)
      : super(QpiProjectCalculationState(false, const AsyncLoading(), ''));

  qpiCalculation(var projectId) async {
    state = _loading();
    final data =
    await ref.read(apiProvider).qpiCalculation(projectId);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  QpiProjectCalculationState _dataState(List<QPIProjectCalculationProjectById> entity) {
    return QpiProjectCalculationState(false, AsyncData(entity), '');
  }

  QpiProjectCalculationState _loading() {
    return QpiProjectCalculationState(true, state.projectId, '');
  }

  QpiProjectCalculationState _errorState(int statusCode, String errMsg) {
    return QpiProjectCalculationState(
        false, state.projectId, 'response code $statusCode  msg $errMsg');
  }
}