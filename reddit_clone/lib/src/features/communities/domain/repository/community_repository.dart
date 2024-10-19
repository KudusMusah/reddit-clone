import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';

abstract interface class CommunityRepository {
  Future<Either<Failure, void>> createCommunity(String name, String creatorUid);
}
