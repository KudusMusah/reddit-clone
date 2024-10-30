import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_image_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_link_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_text_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/downvote_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/get_post_with_id_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/upvote_post_usecase.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final CreateImagePostUsecase _createImagePostUsecase;
  final CreateTextPostUsecase _createTextPostUsecase;
  final CreateLinkPostUsecase _createLinkPostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final UpvotePostUsecase _upvotePostUsecase;
  final DownvotePostUsecase _downvotePostUsecase;
  final GetPostWithIdUsecase _getPostWithIdUsecase;
  final CreateCommentUsecase _createCommentUsecase;

  PostsBloc({
    required CreateImagePostUsecase createImagePostUsecase,
    required CreateTextPostUsecase createTextPostUsecase,
    required CreateLinkPostUsecase createLinkPostUsecase,
    required DeletePostUsecase deletePostUsecase,
    required UpvotePostUsecase upvotePostUsecase,
    required DownvotePostUsecase downvotePostUsecase,
    required GetPostWithIdUsecase getPostWithIdUsecase,
    required CreateCommentUsecase createCommentUsecase,
  })  : _createImagePostUsecase = createImagePostUsecase,
        _createTextPostUsecase = createTextPostUsecase,
        _createLinkPostUsecase = createLinkPostUsecase,
        _deletePostUsecase = deletePostUsecase,
        _upvotePostUsecase = upvotePostUsecase,
        _downvotePostUsecase = downvotePostUsecase,
        _getPostWithIdUsecase = getPostWithIdUsecase,
        _createCommentUsecase = createCommentUsecase,
        super(PostsInitial()) {
    on<CreateImagePost>(onCreateImagePost);
    on<CreateTextPost>(onCreateTextPost);
    on<CreateLinkPost>(onCreateLinkPost);
    on<DeletePost>(onDeletePost);
    on<UpvotePost>(onUpvotePost);
    on<DownvotePost>(onDownvotePost);
    on<GetPostWithId>(onGetPostWithId);
    on<CreateComment>(onCreateComment);
  }

  void onCreateImagePost(
    CreateImagePost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _createImagePostUsecase(
      CreateImagePostparams(
        image: event.image,
        title: event.title,
        community: event.community,
        user: event.user,
      ),
    );

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onCreateTextPost(
    CreateTextPost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _createTextPostUsecase(
      CreateTextPostparams(
        title: event.title,
        description: event.description,
        community: event.community,
        user: event.user,
      ),
    );

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onCreateLinkPost(
    CreateLinkPost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _createLinkPostUsecase(
      CreateLinkPostparams(
        title: event.title,
        link: event.link,
        community: event.community,
        user: event.user,
      ),
    );

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onDeletePost(
    DeletePost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res =
        await _deletePostUsecase(DeletePostParams(postId: event.postId));

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onUpvotePost(
    UpvotePost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _upvotePostUsecase(UpvotePostParams(
      post: event.post,
      userId: event.userId,
    ));

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onGetPostWithId(
    GetPostWithId event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _getPostWithIdUsecase(GetPostWithIdParams(id: event.id));

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(GetPostSuccess(post: r)),
    );
  }

  void onDownvotePost(
    DownvotePost event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final res = await _downvotePostUsecase(DownvotePostParams(
      post: event.post,
      userId: event.userId,
    ));

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) => emit(PostsSuccess()),
    );
  }

  void onCreateComment(CreateComment event, Emitter<PostsState> emit) async {
    final res = await _createCommentUsecase(CreateCommentParams(
      text: event.text,
      postId: event.postId,
      username: event.username,
      profilePic: event.profilePic,
    ));

    res.fold(
      (l) => emit(PostsFailure(message: l.message)),
      (r) {},
    );
  }
}
