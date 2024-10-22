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
