import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/constants/constants.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/mappers/community_mapper.dart';
import 'package:reddit_clone/src/features/communities/data/datasources/community_remote_datasource.dart';
import 'package:reddit_clone/src/features/communities/data/models/community_model.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDatasource communityRemoteDatasource;
  CommunityRepositoryImpl({required this.communityRemoteDatasource});

  @override
  Future<Either<Failure, void>> createCommunity(
    String name,
    String creatorUid,
  ) async {
    try {
      final community = CommunityModel(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        profileImage: Constants.avatarDefault,
        members: [creatorUid],
        mods: [creatorUid],
      );
      await communityRemoteDatasource.createCommunity(community);
      return right(null);
    } on CommunityException catch (e) {
      return left(CommunityFailure(e.message));
    }
  }

  @override
  Either<Failure, Stream<List<CommunityModel>>> getUserCommunities(String uid) {
    return right(communityRemoteDatasource.getUserCommunities(uid));
  }

  @override
  Either<Failure, Stream<CommunityModel>> getCommunity(String name) {
    return right(communityRemoteDatasource.getCommunity(name));
  }

  @override
  Future<Either<Failure, void>> editCommunity(
    CommunityEntity community,
    File? profileImage,
    File? bannerImage,
  ) async {
    try {
      CommunityModel comm = CommunityMapper.entityToModel(community);

      if (profileImage != null) {
        final url = await communityRemoteDatasource.uploadImage(
            "community/profile", comm.id, profileImage);
        comm = comm.copyWith(profileImage: url);
      }

      if (bannerImage != null) {
        final url = await communityRemoteDatasource.uploadImage(
            "community/banner", comm.id, bannerImage);
        comm = comm.copyWith(banner: url);
      }

      await communityRemoteDatasource.updateCommunity(comm);
      return right(null);
    } on CommunityException catch (e) {
      return left(Failure(e.message));
    }
  }
}
