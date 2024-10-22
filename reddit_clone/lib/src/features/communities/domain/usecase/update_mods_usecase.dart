import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class UpdateModsUsecase implements Usecase<void, UpdateModsParams> {
  final CommunityRepository communityRepository;
  UpdateModsUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, void>> call(UpdateModsParams params) {
    return communityRepository.updateMods(params.communityName, params.mods);
  }
}

class UpdateModsParams {
  final String communityName;
  final List<String> mods;

  UpdateModsParams({required this.communityName, required this.mods});
}
