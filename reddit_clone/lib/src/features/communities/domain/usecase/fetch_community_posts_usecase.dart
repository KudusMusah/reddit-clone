import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';

class FetchCommunityPostsUsecase
    implements Usecase<Stream<List<PostEntity>>, GetCommunityPostsParams> {
  final CommunityRepository communityRepository;
  FetchCommunityPostsUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, Stream<List<PostEntity>>>> call(
    GetCommunityPostsParams params,
  ) async {
    return communityRepository.fetchCommunityPosts(params.communityName);
  }
}

class GetCommunityPostsParams {
  final String communityName;

  GetCommunityPostsParams({required this.communityName});
}
