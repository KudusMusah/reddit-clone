import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class LeaveCommunityUsease implements Usecase<void, LeaveCommunityParams> {
  final CommunityRepository communityRepository;
  LeaveCommunityUsease({required this.communityRepository});

  @override
  Future<Either<Failure, void>> call(LeaveCommunityParams params) async {
    return await communityRepository.leaveCommunity(
        params.communityName, params.userId);
  }
}

class LeaveCommunityParams {
  final String communityName;
  final String userId;
  LeaveCommunityParams({
    required this.communityName,
    required this.userId,
  });
}
