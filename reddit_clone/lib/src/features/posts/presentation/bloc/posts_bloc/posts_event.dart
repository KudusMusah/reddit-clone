part of 'posts_bloc.dart';

@immutable
sealed class PostsEvent {}

class CreateImagePost extends PostsEvent {
  final File image;
  final String title;
  final CommunityEntity community;
  final UserEntity user;

  CreateImagePost({
    required this.image,
    required this.title,
    required this.community,
    required this.user,
  });
}

class CreateTextPost extends PostsEvent {
  final String description;
  final String title;
  final CommunityEntity community;
  final UserEntity user;

  CreateTextPost({
    required this.title,
    required this.description,
    required this.community,
    required this.user,
  });
}

class CreateLinkPost extends PostsEvent {
  final String title;
  final String link;
  final CommunityEntity community;
  final UserEntity user;

  CreateLinkPost({
    required this.title,
    required this.link,
    required this.community,
    required this.user,
  });
}
