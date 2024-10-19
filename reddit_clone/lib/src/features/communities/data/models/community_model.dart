import 'package:reddit_clone/src/core/entities/community_entity.dart';

class CommunityModel extends CommunityEntity {
  CommunityModel({
    required super.id,
    required super.name,
    required super.banner,
    required super.profileImage,
    required super.members,
    required super.mods,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'profileImage': profileImage,
      'members': members,
      'mods': mods,
    };
  }

  factory CommunityModel.fromJson(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      profileImage: map['profileImage'] as String,
      members: List<String>.from((map['members'] as List<dynamic>)),
      mods: List<String>.from(
        (map['mods'] as List<dynamic>),
      ),
    );
  }
}
