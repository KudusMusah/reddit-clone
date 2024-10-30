part of 'posts_comments_bloc.dart';

@immutable
sealed class PostsCommentsEvent {}

class GetpostComments extends PostsCommentsEvent {
  final String postId;

  GetpostComments({required this.postId});
}

class PostCommentsFetched extends PostsCommentsEvent {
  final List<CommentEntity> comments;

  PostCommentsFetched({required this.comments});
}

class PostCommentsFailed extends PostsCommentsEvent {
  final String message;

  PostCommentsFailed({required this.message});
}
