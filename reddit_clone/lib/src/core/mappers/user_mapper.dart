import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/common/models/user_model.dart';

class UserMapper {
  static UserModel entityToModel(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      banner: entity.banner,
      profilePic: entity.profilePic,
      karma: entity.karma,
      awards: entity.awards,
      isAuthenticated: entity.isAuthenticated,
    );
  }

  static UserEntity modelToEntity(UserModel model) {
    return UserEntity(
      uid: model.uid,
      name: model.name,
      banner: model.banner,
      profilePic: model.profilePic,
      karma: model.karma,
      awards: model.awards,
      isAuthenticated: model.isAuthenticated,
    );
  }
}
