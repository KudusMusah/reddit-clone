import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';

abstract interface class PostRepository {
  Future<Either<PostFailure, void>> createImagePost(
    String title,
    File image,
    CommunityEntity community,
    UserEntity user,
  );
  Future<Either<PostFailure, void>> createTextPost(
    String title,
    String description,
    CommunityEntity community,
    UserEntity user,
  );
  Future<Either<PostFailure, void>> createLinkPost(
    String title,
    String link,
    CommunityEntity community,
    UserEntity user,
  );
  Future<Either<PostFailure, Stream<List<PostEntity>>>> fetchUserFeed(
    List<CommunityEntity> communities,
  );
}
