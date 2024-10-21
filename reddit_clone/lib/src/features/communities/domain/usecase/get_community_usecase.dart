import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/repository/community_repository.dart';

class GetCommunityUsecase
    implements Usecase<Stream<CommunityEntity>, GetCommunityParams> {
  final CommunityRepository communityRepository;
  GetCommunityUsecase({required this.communityRepository});

  @override
  Future<Either<Failure, Stream<CommunityEntity>>> call(
    GetCommunityParams params,
  ) async {
    return communityRepository.getCommunity(params.name);
  }
}

class GetCommunityParams {
  final String name;

  GetCommunityParams({required this.name});
}
