import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/fetch_community_posts_usecase.dart';

part 'community_posts_event.dart';
part 'community_posts_state.dart';

class CommunityPostsBloc
    extends Bloc<CommunityPostsEvent, CommunityPostsState> {
  final FetchCommunityPostsUsecase _fetchCommunityPostsUsecase;

  CommunityPostsBloc({
    required FetchCommunityPostsUsecase fetchCommunityPostsUsecase,
  })  : _fetchCommunityPostsUsecase = fetchCommunityPostsUsecase,
        super(CommunityPostsInitial()) {
    on<CommunityPostsEvent>((event, emit) {});
    on<FetchCommunityPosts>(onFetchCommunityPosts);
    on<OnPostsFailed>(
        (event, emit) => emit(CommunityPostsFailure(message: event.message)));
    on<OnPostsFetched>(
        (event, emit) => emit(CommunityPostsSuccess(posts: event.posts)));
  }

  void onFetchCommunityPosts(
    FetchCommunityPosts event,
    Emitter<CommunityPostsState> emit,
  ) async {
    emit(CommunityPostsLoading());
    final res = await _fetchCommunityPostsUsecase(
        GetCommunityPostsParams(communityName: event.communityName));

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
