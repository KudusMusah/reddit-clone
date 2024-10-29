part of 'user_posts_bloc.dart';

@immutable
sealed class UserPostsState {}

final class UserPostsInitial extends UserPostsState {}

final class UserPostsLoading extends UserPostsState {}

final class UserPostsFailure extends UserPostsState {
  final String message;
  UserPostsFailure({required this.message});
}

final class UserPostsSuccess extends UserPostsState {
  final List<PostEntity> posts;
  UserPostsSuccess({required this.posts});
}
