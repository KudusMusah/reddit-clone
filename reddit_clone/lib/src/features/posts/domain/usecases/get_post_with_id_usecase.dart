import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class GetPostWithIdUsecase implements Usecase<PostEntity, GetPostWithIdParams> {
  final PostRepository postRepository;
  GetPostWithIdUsecase({required this.postRepository});

  @override
  Future<Either<Failure, PostEntity>> call(GetPostWithIdParams params) async {
    return postRepository.getPostWithId(params.id);
  }
}

class GetPostWithIdParams {
  final String id;

  GetPostWithIdParams({required this.id});
}
