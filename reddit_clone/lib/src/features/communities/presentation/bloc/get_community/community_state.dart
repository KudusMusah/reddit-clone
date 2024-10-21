part of 'community_bloc.dart';

@immutable
sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class CommunityLoading extends CommunityState {}

final class GetCommunitySuccess extends CommunityState {
  final CommunityEntity community;
  GetCommunitySuccess({required this.community});
}

final class CommunityFailureState extends CommunityState {
  final String message;
  CommunityFailureState(this.message);
}
