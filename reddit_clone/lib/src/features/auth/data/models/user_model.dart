import 'package:reddit_clone/src/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.profilePic,
    required super.banner,
    required super.karma,
    required super.awards,
    required super.isAuthenticated,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'banner': banner, 
      'karma': karma,
      'awards': awards,
      'isAuthenticated': isAuthenticated,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      karma: map['karma'] as int,
      awards: List<String>.from(
        (map['awards'] as List<dynamic>),
      ),
      isAuthenticated: map['isAuthenticated'] as bool,
    );
  }
}