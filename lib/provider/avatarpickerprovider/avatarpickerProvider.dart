import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/helper.dart';

final avatarNotifier = StateNotifierProvider<AvatarProvider, String>((ref) {
  return AvatarProvider(ref);
});

class AvatarProvider extends StateNotifier<String> {
  final Ref ref;

  AvatarProvider(this.ref) : super(Helper.avatar);

  void currentAvatar(String image) {
    state = image;
  }
}
