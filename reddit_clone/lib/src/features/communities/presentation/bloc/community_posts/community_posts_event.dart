part of 'community_posts_bloc.dart';

@immutable
sealed class CommunityPostsEvent {}

final class FetchCommunityPosts extends CommunityPostsEvent {
  final String communityName;

  FetchCommunityPosts({required this.communityName});
}

final class OnPostsFetched extends CommunityPostsEvent {
  final List<PostEntity> posts;

  OnPostsFetched({required this.posts});
}

final class OnPostsFailed extends CommunityPostsEvent {
  final String message;

  OnPostsFailed({required this.message});
}
