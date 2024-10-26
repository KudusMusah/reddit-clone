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

class ProfileException extends Exception {
  ProfileException(super.message);
}

class PostException extends Exception {
  PostException(super.message);
}
