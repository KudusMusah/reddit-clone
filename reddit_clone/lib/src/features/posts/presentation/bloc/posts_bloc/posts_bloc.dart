import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_image_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_link_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/create_text_post_usecase.dart';
import 'package:reddit_clone/src/features/posts/domain/usecases/delete_post_usecase.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final CreateImagePostUsecase _createImagePostUsecase;
  final CreateTextPostUsecase _createTextPostUsecase;
  final CreateLinkPostUsecase _createLinkPostUsecase;
  final DeletePostUsecase _deletePostUsecase;

  PostsBloc({
    required CreateImagePostUsecase createImagePostUsecase,
    required CreateTextPostUsecase createTextPostUsecase,
    required CreateLinkPostUsecase createLinkPostUsecase,
    required DeletePostUsecase deletePostUsecase,
  })  : _createImagePostUsecase = createImagePostUsecase,
        _createTextPostUsecase = createTextPostUsecase,
        _createLinkPostUsecase = createLinkPostUsecase,
        _deletePostUsecase = deletePostUsecase,
        super(PostsInitial()) {
    on<CreateImagePost>(onCreateImagePost);
    on<CreateTextPost>(onCreateTextPost);
    on<CreateLinkPost>(onCreateLinkPost);
    on<DeletePost>(onDeletePost);
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
}
