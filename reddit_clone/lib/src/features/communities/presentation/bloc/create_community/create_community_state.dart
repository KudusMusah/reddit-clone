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
