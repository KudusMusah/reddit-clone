import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class JoinCommunityUsecase implements Usecase<void, JoinCommunityParams> {
  final CommunityRepository communityRepository;
  JoinCommunityUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, void>> call(JoinCommunityParams params) async {
    return await communityRepository.joinCommunity(
        params.communityName, params.userId);
  }
}

class JoinCommunityParams {
  final String communityName;
  final String userId;
  JoinCommunityParams({
    required this.communityName,
    required this.userId,
  });
}
