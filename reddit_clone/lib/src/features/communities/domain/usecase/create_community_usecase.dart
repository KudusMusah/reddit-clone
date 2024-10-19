import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class CreateCommunityUsecase implements Usecase<void, CreateCommunityParams> {
  final CommunityRepository communityRepository;
  CreateCommunityUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, void>> call(CreateCommunityParams params) async {
    return await communityRepository.createCommunity(
        params.name, params.creatorUid);
  }
}

class CreateCommunityParams {
  final String name;
  final String creatorUid;

  CreateCommunityParams({required this.name, required this.creatorUid});
}
