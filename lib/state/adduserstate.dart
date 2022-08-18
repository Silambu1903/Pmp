import 'package:riverpod/riverpod.dart';

import '../model/login_model.dart';



class AddUserSate {
  bool isLoading;
  AsyncValue<String> id;
  String error;

  AddUserSate(this.isLoading,this.id, this.error);


}