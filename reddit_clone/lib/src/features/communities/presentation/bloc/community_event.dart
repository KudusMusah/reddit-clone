part of 'community_bloc.dart';

@immutable
sealed class CommunityEvent {}

class CreateCommunity extends CommunityEvent {
  final String name;
  final String creatorUid;

  CreateCommunity({required this.name, required this.creatorUid});
}
