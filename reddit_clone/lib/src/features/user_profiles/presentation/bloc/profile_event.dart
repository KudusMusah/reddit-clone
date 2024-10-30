part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class EditProfile extends ProfileEvent {
  final UserEntity profile;
  final File? banner;
  final File? profileImage;
  final String name;

  EditProfile({
    required this.profile,
    required this.banner,
    required this.profileImage,
    required this.name,
  });
}

final class UpdateKarma extends ProfileEvent {
  final String uid;
  final UserKarma karma;

  UpdateKarma({
    required this.uid,
    required this.karma,
  });
}
