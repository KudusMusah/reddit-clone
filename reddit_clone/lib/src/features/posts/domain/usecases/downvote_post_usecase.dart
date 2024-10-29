import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class DownvotePostUsecase implements Usecase<void, DownvotePostParams> {
  final PostRepository postRepository;
  DownvotePostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(DownvotePostParams params) async {
    return await postRepository.downVotePost(params.post, params.userId);
  }
}

class DownvotePostParams {
  final PostEntity post;
  final String userId;

  DownvotePostParams({required this.post, required this.userId});
}
