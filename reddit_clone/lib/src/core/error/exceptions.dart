class Exception {
  final String message;

  Exception(this.message);
}

class AuthException extends Exception {
  AuthException(super.message);
}

class CommunityException extends Exception {
  CommunityException(super.message);
}
