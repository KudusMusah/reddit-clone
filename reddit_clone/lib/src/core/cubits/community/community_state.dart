part of 'community_cubit.dart';

@immutable
sealed class UserCommunitiesState {}

class UserCommunitiesInitial extends UserCommunitiesState {}

class UserCommunitiesLoading extends UserCommunitiesState {}

final class UserCommunitiesFailure extends UserCommunitiesState {
  final String message;

  UserCommunitiesFailure({required this.message});
}

final class UserCommunitiesSucess extends UserCommunitiesState {
  final List<CommunityEntity> communities;

  UserCommunitiesSucess({required this.communities});
}
