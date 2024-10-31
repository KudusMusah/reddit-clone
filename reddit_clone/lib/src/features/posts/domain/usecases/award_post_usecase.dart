import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/repository/post_repository.dart';

class AwardPostUsecase implements Usecase<void, AwardPostparams> {
  final PostRepository postRepository;
  AwardPostUsecase({required this.postRepository});

  @override
  Future<Either<Failure, void>> call(AwardPostparams params) async {
    return await postRepository.awardpost(
      params.award,
      params.postId,
      params.userId,
      params.posterid,
    );
  }
}

class AwardPostparams {
  String award;
  String postId;
  String userId;
  String posterid;
  AwardPostparams({
    required this.award,
    required this.postId,
    required this.userId,
    required this.posterid,
  });
}
