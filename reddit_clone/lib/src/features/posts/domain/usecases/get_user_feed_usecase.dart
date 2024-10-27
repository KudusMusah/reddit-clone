import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class GetUserFeedUsecase
    implements Usecase<Stream<List<PostEntity>>, GetUserFeedParams> {
  final PostRepository postRepository;
  GetUserFeedUsecase({required this.postRepository});

  @override
  Future<Either<Failure, Stream<List<PostEntity>>>> call(
    GetUserFeedParams params,
  ) async {
    return postRepository.fetchUserFeed(params.communities);
  }
}

class GetUserFeedParams {
  final List<CommunityEntity> communities;

  GetUserFeedParams({required this.communities});
}
