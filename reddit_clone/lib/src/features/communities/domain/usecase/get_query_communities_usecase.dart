import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class GetQueryCommunitiesUsecase
    implements Usecase<Stream<List<CommunityEntity>>, CommunityQueryParams> {
  final CommunityRepository communityRepository;
  GetQueryCommunitiesUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, Stream<List<CommunityEntity>>>> call(
    CommunityQueryParams params,
  ) async {
    return communityRepository.getQueryCommunities(params.query);
  }
}

class CommunityQueryParams {
  final String query;

  CommunityQueryParams({required this.query});
}
