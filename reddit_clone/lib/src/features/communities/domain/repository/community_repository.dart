import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';

abstract interface class CommunityRepository {
  Future<Either<Failure, void>> createCommunity(String name, String creatorUid);
  Either<Failure, Stream<List<CommunityEntity>>> getUserCommunities(String uid);
  Either<Failure, Stream<CommunityEntity>> getCommunity(String name);
  Future<Either<Failure, void>> editCommunity(
      CommunityEntity community, File? profileImage, File? bannerImage);
  Either<Failure, Stream<List<CommunityEntity>>> getQueryCommunities(
      String query);
  Future<Either<Failure, void>> joinCommunity(
      String communityName, String userId);
  Future<Either<Failure, void>> leaveCommunity(
      String communityName, String userId);
  Future<Either<Failure, List<UserEntity>>> getCommunityMembers(
      String communityName);
  Future<Either<Failure, void>> updateMods(
      String communityName, List<String> mods);
  Either<Failure, Stream<List<PostEntity>>> fetchCommunityPosts(
    String communityName,
  );
}
