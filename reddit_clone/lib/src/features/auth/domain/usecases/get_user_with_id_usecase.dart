import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/auth/data/models/user_model.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';

class GetUserWithIdUsecase
    implements Usecase<Stream<UserModel>, GetUserParams> {
  final AuthRepository authRepository;
  GetUserWithIdUsecase({required this.authRepository});

  @override
  Future<Either<Failure, Stream<UserModel>>> call(GetUserParams params) async {
    return authRepository.getUserWithId(params.uid);
  }
}

class GetUserParams {
  final String uid;

  GetUserParams({required this.uid});
}
