import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';

class AuthStateChangesUsecases implements Usecase<Stream<User?>, NoParams> {
  final AuthRepository authRepository;
  AuthStateChangesUsecases({required this.authRepository});

  @override
  Future<Either<Failure, Stream<User?>>> call(NoParams params) async {
    return authRepository.authStateChanges();
  }
}
