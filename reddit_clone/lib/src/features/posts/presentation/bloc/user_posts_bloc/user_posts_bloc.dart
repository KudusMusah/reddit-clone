import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/fetch_user_posts_usecase.dart';

part 'user_posts_event.dart';
part 'user_posts_state.dart';

class UserPostsBloc extends Bloc<UserPostsEvent, UserPostsState> {
  final FetchUserPostsUsecase _fetchUserPostsUsecase;
  UserPostsBloc({
    required FetchUserPostsUsecase fetchUserPostsUsecase,
  })  : _fetchUserPostsUsecase = fetchUserPostsUsecase,
        super(UserPostsInitial()) {
    on<FetchUserPosts>(onFetchUserPosts);
    on<OnPostsFailed>(
        (event, emit) => emit(UserPostsFailure(message: event.message)));
    on<OnPostsFetched>(
        (event, emit) => emit(UserPostsSuccess(posts: event.posts)));
  }

  void onFetchUserPosts(
    FetchUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    final res =
        await _fetchUserPostsUsecase(GetUserPostsParams(uid: event.uid));

    res.fold(
      (l) => add(OnPostsFailed(message: l.message)),
      (r) {
        r.listen(
          (posts) {
            add(OnPostsFetched(posts: posts));
          },
          onError: (object) {
            add(
              OnPostsFailed(message: "An unexpected error occured"),
            );
          },
        );
      },
    );
  }
}
