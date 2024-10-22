part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

final class GetUserCommunities extends CommunityEvent {
  final String uid;
  GetUserCommunities(this.uid);
}

final class GetCommunity extends CommunityEvent {
  final String name;
  GetCommunity(this.name);
}

final class GetCommunityDone extends CommunityEvent {
  final CommunityEntity community;
  GetCommunityDone(this.community);
}

final class GetCommunityFailed extends CommunityEvent {
  final String message;
  GetCommunityFailed(this.message);
}
