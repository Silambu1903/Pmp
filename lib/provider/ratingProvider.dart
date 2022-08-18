import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/ratingModel.dart';
import '../service/apiService.dart';

final ratingNotifierProvider = StateNotifierProvider<RatingNotifier, List<RatingModel>>((ref){
  return RatingNotifier(ref);
});

class RatingNotifier extends StateNotifier<List<RatingModel>> {
  final Ref ref;

  RatingNotifier(this.ref) : super([]);

  getRatingList() async {
    state = await ref.read(apiProvider).getRatingList();
  }

}