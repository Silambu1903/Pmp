class ExceptionHandle {
  bool? isLoading;
  dynamic error;


  ExceptionHandle({
    this.isLoading = false,
    this.error,
  });
}


class SocketHandle {
  String ? error;

  SocketHandle({
    this.error,
  });
}
