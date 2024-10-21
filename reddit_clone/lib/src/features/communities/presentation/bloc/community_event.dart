part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

class CreateCommunity extends CommunityEvent {
  final String name;
  final String creatorUid;

  CreateCommunity({required this.name, required this.creatorUid});
}

class EditCommunityEvent extends CommunityEvent {
  final CommunityEntity community;
  final File? profileImage;
  final File? bannerImage;
  EditCommunityEvent({
    required this.community,
    required this.profileImage,
    required this.bannerImage,
  });
}

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
