import 'package:riverpod/riverpod.dart';

import '../model/qpi_project_calculation_project_by_id.dart';



class QpiProjectCalculationState {
  bool isLoading;
  AsyncValue<List<QPIProjectCalculationProjectById>> projectId;
  String error;

  QpiProjectCalculationState(this.isLoading, this.projectId, this.error);
}