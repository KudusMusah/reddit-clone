import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/comments.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/get_post_comments_usecase.dart';

part 'posts_comments_event.dart';
part 'posts_comments_state.dart';

class PostsCommentsBloc extends Bloc<PostsCommentsEvent, PostsCommentsState> {
  final GetPostCommentsUsecase _getPostCommentsUsecase;
  PostsCommentsBloc({
    required GetPostCommentsUsecase getPostCommentsUsecase,
  })  : _getPostCommentsUsecase = getPostCommentsUsecase,
        super(PostsCommentsInitial()) {
    on<GetpostComments>(onGetpostComments);
    on<PostCommentsFailed>(
      (event, emit) => emit(PostsCommentsFailure(message: event.message)),
    );
    on<PostCommentsFetched>(
      (event, emit) => emit(PostsCommentsSuccess(comments: event.comments)),
    );
  }

  void onGetpostComments(
      GetpostComments event, Emitter<PostsCommentsState> emit) async {
    emit(PostsCommentsLoading());
    final res = await _getPostCommentsUsecase(
        GetCommunityCommentsParams(postId: event.postId));

    res.fold(
      (l) => emit(PostsCommentsFailure(message: l.message)),
      (r) {
        r.listen(
          (data) => add(PostCommentsFetched(comments: data)),
          onError: (object) {
            print(object.toString());
            add(PostCommentsFailed(message: "An unexpected error occured"));
          },
        );
      },
    );
  }
}
