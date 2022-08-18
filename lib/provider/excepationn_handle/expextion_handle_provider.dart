import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/expection_handle.dart';

final exceptionHandleStateNotifierProvider =
    StateNotifierProvider<ExceptionHandleProvider, ExceptionHandle>(
        (ref) => ExceptionHandleProvider(ref));

class ExceptionHandleProvider extends StateNotifier<ExceptionHandle> {
  final Ref ref;

  ExceptionHandleProvider(this.ref)
      : super(ExceptionHandle(isLoading: false, error: ''));

  dataHandler(bool loadingStatus, dynamic error) {
    state = ExceptionHandle(isLoading: loadingStatus, error: error);
  }
}
