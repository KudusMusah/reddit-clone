import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class CreateCommentUsecase implements Usecase<void, CreateCommentParams> {
  final PostRepository postRepository;
  CreateCommentUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(CreateCommentParams params) async {
    return await postRepository.createComment(
        params.text, params.postId, params.username, params.profilePic);
  }
}

class CreateCommentParams {
  final String text;
  final String postId;
  final String username;
  final String profilePic;

  CreateCommentParams({
    required this.text,
    required this.postId,
    required this.username,
    required this.profilePic,
  });
}
