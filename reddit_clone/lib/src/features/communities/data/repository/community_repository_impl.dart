import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/constants/constants.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/features/communities/data/datasources/community_remote_datasource.dart';
import 'package:reddit_clone/src/features/communities/data/models/community_model.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDatasource communityRemoteDatasource;
  CommunityRepositoryImpl({required this.communityRemoteDatasource});

  @override
  Future<Either<Failure, void>> createCommunity(
      String name, String creatorUid) async {
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
}
