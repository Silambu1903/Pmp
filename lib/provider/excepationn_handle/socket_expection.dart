import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/expection_handle.dart';

final   socketHandleStateNotifierProvider =
StateNotifierProvider<SocketHandleProvider, String>(
        (ref) => SocketHandleProvider(ref));

class SocketHandleProvider extends StateNotifier<String> {
  final Ref ref;

  SocketHandleProvider(this.ref)
      : super('');

  dataHandler(dynamic error) {
    state = error;
  }
}