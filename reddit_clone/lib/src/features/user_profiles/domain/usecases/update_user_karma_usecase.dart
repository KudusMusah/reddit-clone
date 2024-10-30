import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/enums/karma.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/repository/profile_repository.dart';

class UpdateKarmaUsecase implements Usecase<void, UpdateKarmaParams> {
  final ProfileRepository profileRepository;
  UpdateKarmaUsecase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(UpdateKarmaParams params) async {
    return await profileRepository.updateUserKarma(params.uid, params.karma);
  }
}

class UpdateKarmaParams {
  final String uid;
  final UserKarma karma;

  UpdateKarmaParams({
    required this.uid,
    required this.karma,
  });
}
