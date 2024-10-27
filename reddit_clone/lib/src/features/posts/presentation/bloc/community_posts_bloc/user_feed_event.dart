part of 'user_feed_bloc.dart';

@immutable
sealed class UserFeedEvent {}

class FetchUserFeed extends UserFeedEvent {
  final List<CommunityEntity> communities;

  FetchUserFeed({required this.communities});
}

class PostFetched extends UserFeedEvent {
  final List<PostEntity> posts;

  PostFetched({required this.posts});
}
