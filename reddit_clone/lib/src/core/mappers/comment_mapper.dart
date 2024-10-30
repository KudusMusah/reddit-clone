import 'package:reddit_clone/src/features/posts/data/models/comment_model.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/comments.dart';

class CommentMapper {
  static CommentModel entityToModel(CommentEntity entity) {
    return CommentModel(
      id: entity.id,
      text: entity.text,
      createdAt: entity.createdAt,
      postId: entity.postId,
      username: entity.username,
      profilePic: entity.profilePic,
    );
  }

  static CommentEntity modelToEntity(CommentModel model) {
    return CommentEntity(
      id: model.id,
      text: model.text,
      createdAt: model.createdAt,
      postId: model.postId,
      username: model.username,
      profilePic: model.profilePic,
    );
  }
}
