import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/mappers/comment_mapper.dart';
import 'package:reddit_clone/src/core/mappers/community_mapper.dart';
import 'package:reddit_clone/src/core/mappers/post_mapper.dart';
import 'package:reddit_clone/src/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:reddit_clone/src/core/common/models/post_model.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/comments.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final Uuid uuid;
  PostRepositoryImpl({required this.postRemoteDataSource, required this.uuid});

  @override
  Future<Either<Failure, void>> createImagePost(
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
  Future<Either<Failure, void>> createLinkPost(
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
  Future<Either<Failure, void>> createTextPost(
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
        type: "text",
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
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await postRemoteDataSource.deletePost(postId);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> downVotePost(
    PostEntity post,
    String userId,
  ) async {
    try {
      final p = PostMapper.entityToModel(post);
      await postRemoteDataSource.downVotePost(p, userId);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> upVotePost(
    PostEntity post,
    String userId,
  ) async {
    try {
      final p = PostMapper.entityToModel(post);
      await postRemoteDataSource.upVotePost(p, userId);
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<List<PostModel>>> fetchUserFeed(
    List<CommunityEntity> communities,
  ) {
    return right(
      postRemoteDataSource.fetchUserFeed(
        communities.map((comm) => CommunityMapper.entityToModel(comm)).toList(),
      ),
    );
  }

  @override
  Either<Failure, Stream<List<PostModel>>> fetchUserPosts(String uid) {
    return right(postRemoteDataSource.fetchUserPosts(uid));
  }

  @override
  Future<Either<Failure, PostModel>> getPostWithId(String id) async {
    try {
      final post = await postRemoteDataSource.getPostWithId(id);
      return right(post);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createComment(
    String text,
    String postId,
    String username,
    String profilePic,
  ) async {
    try {
      final comment = CommentEntity(
        id: uuid.v1(),
        text: text,
        createdAt: DateTime.now(),
        postId: postId,
        username: username,
        profilePic: profilePic,
      );
      await postRemoteDataSource
          .createComment(CommentMapper.entityToModel(comment));
      return right(null);
    } on PostException catch (e) {
      return left(PostFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<List<CommentEntity>>> getPostComments(String postId) {
    return right(postRemoteDataSource.getPostComments(postId));
  }
}
