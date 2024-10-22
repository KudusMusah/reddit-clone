part of 'create_community_bloc.dart';

@immutable
sealed class CreateCommunityState {}

final class CreateCommunityInitial extends CreateCommunityState {}

final class CreateCommunityLoading extends CreateCommunityState {}

final class CreateCommunitySuccess extends CreateCommunityState {}

final class CreateCommunityFailure extends CreateCommunityState {
  final String message;
  CreateCommunityFailure(this.message);
}

final class GetQueryCommunitySuccess extends CreateCommunityState {
  final List<CommunityEntity> communities;

  GetQueryCommunitySuccess({required this.communities});
}

final class GetCommunityMembersSuccess extends CreateCommunityState {
  final List<UserEntity> members;

  GetCommunityMembersSuccess({required this.members});
}
