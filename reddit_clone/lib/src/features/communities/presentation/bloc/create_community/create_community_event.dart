part of 'create_community_bloc.dart';

@immutable
sealed class CreateCommunityEvent {}

final class CreateCommunity extends CreateCommunityEvent {
  final String name;
  final String creatorUid;

  CreateCommunity({required this.name, required this.creatorUid});
}

final class UpdateCommunityEvent extends CreateCommunityEvent {
  final CommunityEntity community;
  final File? profileImage;
  final File? bannerImage;
  UpdateCommunityEvent({
    required this.community,
    required this.profileImage,
    required this.bannerImage,
  });
}

final class GetQueryCommunities extends CreateCommunityEvent {
  final String query;

  GetQueryCommunities({required this.query});
}

final class QueryCommunitiesFetched extends CreateCommunityEvent {
  final List<CommunityEntity> communities;

  QueryCommunitiesFetched({required this.communities});
}

final class QueryCommunitiesFailed extends CreateCommunityEvent {}

final class JoinCommunity extends CreateCommunityEvent {
  final String communityName;
  final String userId;

  JoinCommunity({required this.communityName, required this.userId});
}

final class LeaveCommunity extends CreateCommunityEvent {
  final String communityName;
  final String userId;

  LeaveCommunity({required this.communityName, required this.userId});
}

final class GetCommunityMembers extends CreateCommunityEvent {
  final String communityName;
  GetCommunityMembers({required this.communityName});
}

final class UpdateMods extends CreateCommunityEvent {
  final String communityName;
  final List<String> mods;

  UpdateMods({required this.communityName, required this.mods});
}
