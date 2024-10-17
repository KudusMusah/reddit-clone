import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/entities/user_entity.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(UserInitial());

  void onUserLoggedOut() {
    emit(UserInitial());
  }

  void onUserLoggedIn(UserEntity user) {
    emit(UserLoggedIn(user));
  }

  void onUserError() {
    emit(UserError());
  }

  void onUserAuthenticated(String uid) {
    emit(UserAuthenticated(uid: uid));
  }
}
