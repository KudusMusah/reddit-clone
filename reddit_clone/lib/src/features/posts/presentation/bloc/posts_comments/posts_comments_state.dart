part of 'posts_comments_bloc.dart';

@immutable
sealed class PostsCommentsState {}

final class PostsCommentsInitial extends PostsCommentsState {}

final class PostsCommentsLoading extends PostsCommentsState {}

final class PostsCommentsFailure extends PostsCommentsState {
  final String message;

  PostsCommentsFailure({required this.message});
}

final class PostsCommentsSuccess extends PostsCommentsState {
  final List<CommentEntity> comments;

  PostsCommentsSuccess({required this.comments});
}
