import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';

class SignOutUsecase implements Usecase<void, NoParams> {
  final AuthRepository authRepository;
  SignOutUsecase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
