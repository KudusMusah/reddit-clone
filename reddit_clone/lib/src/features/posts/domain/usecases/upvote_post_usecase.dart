import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class UpvotePostUsecase implements Usecase<void, UpvotePostParams> {
  final PostRepository postRepository;
  UpvotePostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(UpvotePostParams params) async {
    return await postRepository.upVotePost(params.post, params.userId);
  }
}

class UpvotePostParams {
  final PostEntity post;
  final String userId;

  UpvotePostParams({required this.post, required this.userId});
}
