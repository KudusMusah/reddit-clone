import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/get_user_feed_usecase.dart';

part 'user_feed_event.dart';
part 'user_feed_state.dart';

class UserFeedBloc extends Bloc<UserFeedEvent, UserFeedState> {
  final GetUserFeedUsecase _getUserFeedUsecase;
  UserFeedBloc({
    required GetUserFeedUsecase getUserFeedUsecase,
  })  : _getUserFeedUsecase = getUserFeedUsecase,
        super(UserFeedInitial()) {
    on<FetchUserFeed>(onFetchUserFeed);
    on<PostFetched>((event, emit) => emit(UserFeedSuccess(posts: event.posts)));
  }

  void onFetchUserFeed(
    FetchUserFeed event,
    Emitter<UserFeedState> emit,
  ) async {
    final res = await _getUserFeedUsecase(
      GetUserFeedParams(communities: event.communities),
    );

    res.fold(
      (l) => emit(UserFeedFailure(message: l.message)),
      (r) async {
        r.listen(
          (data) {
            add(PostFetched(posts: data));
          },
          onError: (object) {},
        );
      },
    );
  }
}
