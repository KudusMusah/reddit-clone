part of 'create_community_bloc.dart';

@immutable
sealed class CreateCommunityEvent {}

class CreateCommunity extends CreateCommunityEvent {
  final String name;
  final String creatorUid;

  CreateCommunity({required this.name, required this.creatorUid});
}

class UpdateCommunityEvent extends CreateCommunityEvent {
  final CommunityEntity community;
  final File? profileImage;
  final File? bannerImage;
  UpdateCommunityEvent({
    required this.community,
    required this.profileImage,
    required this.bannerImage,
  });
}
