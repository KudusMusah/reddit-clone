import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class CreateLinkPostUsecase implements Usecase<void, CreateLinkPostparams> {
  final PostRepository postRepository;
  CreateLinkPostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(CreateLinkPostparams params) async {
    return await postRepository.createLinkPost(
      params.title,
      params.link,
      params.community,
      params.user,
    );
  }
}

class CreateLinkPostparams {
  final String title;
  final String link;
  final CommunityEntity community;
  final UserEntity user;

  CreateLinkPostparams({
    required this.title,
    required this.link,
    required this.community,
    required this.user,
  });
}
