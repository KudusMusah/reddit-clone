import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';

abstract interface class CommunityRepository {
  Future<Either<Failure, void>> createCommunity(String name, String creatorUid);
  Either<Failure, Stream<List<CommunityEntity>>> getUserCommunities(String uid);
  Either<Failure, Stream<CommunityEntity>> getCommunity(String name);
  Future<Either<Failure, void>> editCommunity(
      CommunityEntity community, File? profileImage, File? bannerImage);
}
