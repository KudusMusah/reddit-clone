import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class GetUserCommunitiesUsecase
    implements
        Usecase<Stream<List<CommunityEntity>>, GetUserCommunitiesParams> {
  final CommunityRepository communityRepository;
  GetUserCommunitiesUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, Stream<List<CommunityEntity>>>> call(
    GetUserCommunitiesParams params,
  ) async {
    return communityRepository.getUserCommunities(params.uid);
  }
}

class GetUserCommunitiesParams {
  final String uid;

  GetUserCommunitiesParams({required this.uid});
}
