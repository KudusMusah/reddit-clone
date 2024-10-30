part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsSuccess extends PostsState {}

final class PostsFailure extends PostsState {
  final String message;

  PostsFailure({required this.message});
}

final class GetPostSuccess extends PostsState {
  final PostEntity post;

  GetPostSuccess({required this.post});
}
