import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/models/community_model.dart';

class CommunityMapper {
  static CommunityModel entityToModel(CommunityEntity entity) {
    return CommunityModel(
      id: entity.id,
      name: entity.name,
      banner: entity.banner,
      profileImage: entity.profileImage,
      members: entity.members,
      mods: entity.mods,
    );
  }

  static CommunityEntity modelToEntity(CommunityModel model) {
    return CommunityEntity(
      id: model.id,
      name: model.name,
      banner: model.banner,
      profileImage: model.profileImage,
      members: model.members,
      mods: model.mods,
    );
  }
}
