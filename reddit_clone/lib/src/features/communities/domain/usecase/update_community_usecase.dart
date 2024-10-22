import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class UpdateCommunityUsecase implements Usecase<void, UpdateCommunityParams> {
  final CommunityRepository communityRepository;
  UpdateCommunityUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, void>> call(UpdateCommunityParams params) async {
    return await communityRepository.editCommunity(
        params.community, params.profileImage, params.bannerImage);
  }
}

class UpdateCommunityParams {
  final CommunityEntity community;
  final File? profileImage;
  final File? bannerImage;

  UpdateCommunityParams({
    required this.community,
    required this.profileImage,
    required this.bannerImage,
  });
}
