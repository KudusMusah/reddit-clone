part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

class GetUserCommunities extends CommunityEvent {
  final String uid;
  GetUserCommunities(this.uid);
}

class GetCommunity extends CommunityEvent {
  final String name;
  GetCommunity(this.name);
}

class GetCommunityDone extends CommunityEvent {
  final CommunityEntity community;
  GetCommunityDone(this.community);
}

class GetCommunityFailed extends CommunityEvent {
  final String message;
  GetCommunityFailed(this.message);
}
