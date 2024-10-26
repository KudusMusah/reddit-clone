class Failure {
  final String message;

  Failure([this.message = "An unexpected error occured"]);
}

class AuthFailure extends Failure {
  AuthFailure([super.message]);
}

class CommunityFailure extends Failure {
  CommunityFailure([super.message]);
}

class ProfileFailure extends Failure {
  ProfileFailure([super.message]);
}

class PostFailure extends Failure {
  PostFailure([super.message]);
}
