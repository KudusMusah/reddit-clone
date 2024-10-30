import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/comments.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class GetPostCommentsUsecase
    implements
        Usecase<Stream<List<CommentEntity>>, GetCommunityCommentsParams> {
  final PostRepository postRepository;
  GetPostCommentsUsecase({required this.postRepository});

  @override
  Future<Either<Failure, Stream<List<CommentEntity>>>> call(
    GetCommunityCommentsParams params,
  ) async {
    return postRepository.getPostComments(params.postId);
  }
}

class GetCommunityCommentsParams {
  final String postId;

  GetCommunityCommentsParams({required this.postId});
}
