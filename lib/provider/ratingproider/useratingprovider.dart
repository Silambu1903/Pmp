import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/cumative_performance_model.dart';

import '../../model/overall_rating_model.dart';
import '../../model/ratingvalue.dart';
import '../../service/apiService.dart';
import '../../state/ratingstate.dart';


final getCumulativePerformance = FutureProvider<CumulativeModel>((ref) async {
  return await ref.read(apiProvider).getPerformance();
});

final getOverAllRatingList = FutureProvider<OverAllRatingModel>((ref) async {
  return await ref.read(apiProvider).getOverAllRatingList();
});

final getOverAllRatingDepList = FutureProvider.family<OverAllRatingModel,String>((ref,id) async {
  return await ref.read(apiProvider).getOverAllRatingListDepartmentWise(id);
});

final getOverAllRatingTeamList = FutureProvider.family<OverAllRatingModel,String>((ref,id) async {
  return await ref.read(apiProvider).getOverAllRatingListTeamWise(id);
});


final ratingNotifier =
    StateNotifierProvider<RatingNotifierProvider, RatingTaskSate>((ref) {
  return RatingNotifierProvider(ref);
});

class RatingNotifierProvider extends StateNotifier<RatingTaskSate> {
  Ref ref;

  RatingNotifierProvider(this.ref)
      : super(RatingTaskSate(false, const AsyncLoading(), 'initial'));

  insertRating({String ? empId, var depId, var teamId, RatingValue ? ratingModel ,
      var total}) async {
    state = _loading();
    final data = await ref
        .read(apiProvider)
        .updateRating(empId!, depId, teamId, ratingModel!, total);
    if (data != null) {
      state = _dataState(data);
    }
    return state;
  }

  RatingTaskSate _dataState(String entity) {
    return RatingTaskSate(false, AsyncData(entity), '');
  }

  RatingTaskSate _loading() {
    return RatingTaskSate(true, state.id, '');
  }

  RatingTaskSate _errorState(int statusCode, String errMsg) {
    return RatingTaskSate(
        false, state.id, 'response code $statusCode  msg $errMsg');
  }
}
