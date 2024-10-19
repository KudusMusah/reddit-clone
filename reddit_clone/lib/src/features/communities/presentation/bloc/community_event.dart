// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

class CreateCommunity extends CommunityEvent {
  final String name;
  final String creatorUid;

  CreateCommunity({required this.name, required this.creatorUid});
}

class GetUserCommunities extends CommunityEvent {
  final String uid;
  GetUserCommunities(this.uid);
}
