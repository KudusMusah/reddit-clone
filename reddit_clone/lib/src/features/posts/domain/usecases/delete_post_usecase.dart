import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class DeletePostUsecase implements Usecase<void, DeletePostParams> {
  final PostRepository postRepository;
  DeletePostUsecase({required this.postRepository});
  @override
  Future<Either<Failure, void>> call(DeletePostParams params) async {
    return await postRepository.deletePost(params.postId);
  }
}

class DeletePostParams {
  final String postId;

  DeletePostParams({required this.postId});
}
