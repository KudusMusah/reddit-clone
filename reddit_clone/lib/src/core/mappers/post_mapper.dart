import 'package:reddit_clone/src/features/posts/data/models/post_model.dart';
import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';

class PostMapper {
  static PostModel entityToModel(PostEntity entity) {
    return PostModel(
      id: entity.id,
      title: entity.id,
      communityName: entity.communityName,
      communityProfilePic: entity.communityProfilePic,
      upvotes: entity.upvotes,
      downvotes: entity.downvotes,
      commentCount: entity.commentCount,
      username: entity.username,
      uid: entity.uid,
      type: entity.type,
      createdAt: entity.createdAt,
      awards: entity.awards,
      link: entity.link,
      description: entity.description,
      imageUrl: entity.imageUrl,
    );
  }

  static PostEntity modelToEntity(PostModel model) {
    return PostEntity(
      id: model.id,
      title: model.id,
      communityName: model.communityName,
      communityProfilePic: model.communityProfilePic,
      upvotes: model.upvotes,
      downvotes: model.downvotes,
      commentCount: model.commentCount,
      username: model.username,
      uid: model.uid,
      type: model.type,
      createdAt: model.createdAt,
      awards: model.awards,
      link: model.link,
      description: model.description,
      imageUrl: model.imageUrl,
    );
  }
}
