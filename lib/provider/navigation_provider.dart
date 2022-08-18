import 'package:flutter_riverpod/flutter_riverpod.dart';

final navNotifier = StateNotifierProvider<NavProvider, int>((ref) {
  return NavProvider(ref);
});

class NavProvider extends StateNotifier<int> {
  final Ref ref;

  NavProvider(this.ref) : super(0);

  void currentIndex(int index) {
    state = index;
  }
}
