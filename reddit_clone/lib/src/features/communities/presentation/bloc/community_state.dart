part of 'community_bloc.dart';

@immutable
sealed class CommunityState {}

final class CommunityInitial extends CommunityState {}

final class CommunityLoading extends CommunityState {}

final class CommunitySuccess extends CommunityState {}

final class CommunityFailureState extends CommunityState {
  final String message;

  CommunityFailureState(this.message);
}
