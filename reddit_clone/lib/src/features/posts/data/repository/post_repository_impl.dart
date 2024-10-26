import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:reddit_clone/src/features/posts/data/models/post_model.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final Uuid uuid;
  PostRepositoryImpl({required this.postRemoteDataSource, required this.uuid});

  @override
  Future<Either<PostFailure, void>> createImagePost(
    String title,
    File image,
    CommunityEntity community,
    UserEntity user,
  ) async {
    try {
      PostModel post = PostModel(
        id: uuid.v4(),
        title: title,
        imageUrl: "",
        link: "",
        description: "",
        communityName: community.name,
        communityProfilePic: community.profileImage,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "image",
        createdAt: DateTime.now(),
        awards: [],
      );
      final imageUrl = await postRemoteDataSource.uploadImage(
        "post/${community.name}",
        post.id,
        image,
      );
      post = post.copyWith(imageUrl: imageUrl);
      await postRemoteDataSource.createPost(post);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Future<Either<PostFailure, void>> createLinkPost(
    String title,
    String link,
    CommunityEntity community,
    UserEntity user,
  ) async {
    try {
      PostModel post = PostModel(
        id: uuid.v4(),
        title: title,
        link: link,
        imageUrl: "",
        description: "",
        communityName: community.name,
        communityProfilePic: community.profileImage,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "link",
        createdAt: DateTime.now(),
        awards: [],
      );
      await postRemoteDataSource.createPost(post);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Future<Either<PostFailure, void>> createTextPost(
    String title,
    String description,
    CommunityEntity community,
    UserEntity user,
  ) async {
    try {
      PostModel post = PostModel(
        id: uuid.v4(),
        title: title,
        link: "",
        imageUrl: "",
        description: description,
        communityName: community.name,
        communityProfilePic: community.profileImage,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: "link",
        createdAt: DateTime.now(),
        awards: [],
      );
      await postRemoteDataSource.createPost(post);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }
}
