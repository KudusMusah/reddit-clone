part of 'user_feed_bloc.dart';

@immutable
sealed class UserFeedState {}

final class UserFeedInitial extends UserFeedState {}

final class UserFeedLoading extends UserFeedState {}

final class UserFeedSuccess extends UserFeedState {
  final List<PostEntity> posts;

  UserFeedSuccess({required this.posts});
}

final class UserFeedFailure extends UserFeedState {
  final String message;

  UserFeedFailure({required this.message});
}
