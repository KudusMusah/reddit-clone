part of 'community_posts_bloc.dart';

@immutable
sealed class CommunityPostsState {}

final class CommunityPostsInitial extends CommunityPostsState {}

final class CommunityPostsLoading extends CommunityPostsState {}

final class CommunityPostsFailure extends CommunityPostsState {
  final String message;

  CommunityPostsFailure({required this.message});
}

final class CommunityPostsSuccess extends CommunityPostsState {
  final List<PostEntity> posts;
  CommunityPostsSuccess({required this.posts});
}
