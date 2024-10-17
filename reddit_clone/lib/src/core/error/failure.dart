class Failure {
  final String message;

  Failure([this.message = "An unexpected error occured"]);
}

class AuthFailure extends Failure {
  AuthFailure([super.message]);
}
