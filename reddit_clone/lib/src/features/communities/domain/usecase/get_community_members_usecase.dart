import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class GetCommunityMembersUsecase
    implements Usecase<List<UserEntity>, GetCommunityMembersParams> {
  final CommunityRepository communityRepository;
  GetCommunityMembersUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(
    GetCommunityMembersParams params,
  ) async {
    return await communityRepository.getCommunityMembers(params.communityName);
  }
}

class GetCommunityMembersParams {
  final String communityName;

  GetCommunityMembersParams({required this.communityName});
}
