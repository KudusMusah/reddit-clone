import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';

class SignInWithGooleUsecase implements Usecase<UserEntity, NoParams> {
  final AuthRepository authRepository;
  SignInWithGooleUsecase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
