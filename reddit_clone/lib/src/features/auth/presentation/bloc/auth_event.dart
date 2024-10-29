part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}

class GetSignedInUserData extends AuthEvent {
  final String uid;
  GetSignedInUserData({
    required this.uid,
  });
}

class GetUserData extends AuthEvent {
  final String uid;
  GetUserData({
    required this.uid,
  });
}

class GetUserDataDone extends AuthEvent {
  final UserEntity user;
  GetUserDataDone({
    required this.user,
  });
}

class GetUserDataFailed extends AuthEvent {
  final String message;
  GetUserDataFailed({
    required this.message,
  });
}
