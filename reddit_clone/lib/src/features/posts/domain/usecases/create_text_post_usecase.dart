import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class CreateTextPostUsecase implements Usecase<void, CreateTextPostparams> {
  final PostRepository postRepository;
  CreateTextPostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(CreateTextPostparams params) async {
    return await postRepository.createTextPost(
      params.title,
      params.description,
      params.community,
      params.user,
    );
  }
}

class CreateTextPostparams {
  final String title;
  final String description;
  final CommunityEntity community;
  final UserEntity user;

  CreateTextPostparams({
    required this.title,
    required this.description,
    required this.community,
    required this.user,
  });
}
