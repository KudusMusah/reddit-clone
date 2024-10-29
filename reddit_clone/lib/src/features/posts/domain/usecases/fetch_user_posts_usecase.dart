import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class FetchUserPostsUsecase
    implements Usecase<Stream<List<PostEntity>>, GetUserPostsParams> {
  final PostRepository postRepository;
  FetchUserPostsUsecase({required this.postRepository});

  @override
  Future<Either<Failure, Stream<List<PostEntity>>>> call(
    GetUserPostsParams params,
  ) async {
    return postRepository.fetchUserPosts(params.uid);
  }
}

class GetUserPostsParams {
  final String uid;

  GetUserPostsParams({required this.uid});
}
