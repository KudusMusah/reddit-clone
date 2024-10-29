import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';

abstract interface class PostRepository {
  Future<Either<Failure, void>> createImagePost(
    String title,
    File image,
    CommunityEntity community,
    UserEntity user,
  );
  Future<Either<Failure, void>> createTextPost(
    String title,
    String description,
    CommunityEntity community,
    UserEntity user,
  );
  Future<Either<Failure, void>> createLinkPost(
    String title,
    String link,
    CommunityEntity community,
    UserEntity user,
  );
  Either<Failure, Stream<List<PostEntity>>> fetchUserFeed(
    List<CommunityEntity> communities,
  );
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, void>> downVotePost(PostEntity post, String userId);
  Future<Either<Failure, void>> upVotePost(PostEntity post, String userId);
  Either<Failure, Stream<List<PostEntity>>> fetchUserPosts(String uid);
}
