part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

class UserInitial extends AppUserState {}

class UserLoggedIn extends AppUserState {
  final UserEntity user;

  UserLoggedIn(this.user);
}

class UserError extends AppUserState {}

class UserAuthenticated extends AppUserState {
  final String uid;

  UserAuthenticated({required this.uid});
}
