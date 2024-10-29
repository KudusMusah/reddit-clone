part of 'user_posts_bloc.dart';

@immutable
sealed class UserPostsEvent {}

final class FetchUserPosts extends UserPostsEvent {
  final String uid;

  FetchUserPosts({required this.uid});
}

final class OnPostsFetched extends UserPostsEvent {
  final List<PostEntity> posts;

  OnPostsFetched({required this.posts});
}

final class OnPostsFailed extends UserPostsEvent {
  final String message;

  OnPostsFailed({required this.message});
}
