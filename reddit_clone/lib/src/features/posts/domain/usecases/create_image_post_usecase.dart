import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class CreateImagePostUsecase implements Usecase<void, CreateImagePostparams> {
  final PostRepository postRepository;
  CreateImagePostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(CreateImagePostparams params) async {
    return await postRepository.createImagePost(
      params.title,
      params.image,
      params.community,
      params.user,
    );
  }
}

class CreateImagePostparams {
  final File image;
  final String title;
  final CommunityEntity community;
  final UserEntity user;

  CreateImagePostparams({
    required this.image,
    required this.title,
    required this.community,
    required this.user,
  });
}
