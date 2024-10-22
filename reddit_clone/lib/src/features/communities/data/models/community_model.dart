import 'package:reddit_clone/src/core/common/entities/community_entity.dart';

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

  CommunityModel copyWith({
    String? id,
    String? name,
    String? banner,
    String? profileImage,
    List<String>? members,
    List<String>? mods,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      profileImage: profileImage ?? this.profileImage,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }
}
