import 'package:reddit_clone/src/features/posts/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.title,
    required super.communityName,
    required super.communityProfilePic,
    required super.upvotes,
    required super.downvotes,
    required super.commentCount,
    required super.username,
    required super.uid,
    required super.type,
    required super.createdAt,
    required super.awards,
    super.link,
    super.description,
    super.imageUrl,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? imageUrl,
    String? communityName,
    String? communityProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'imageUrl': imageUrl,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      communityName: map['communityName'] as String,
      communityProfilePic: map['communityProfilePic'] as String,
      upvotes: List<String>.from((map['upvotes'] as List<dynamic>)),
      downvotes: List<String>.from((map['downvotes'] as List<dynamic>)),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: List<String>.from(
        (map['awards'] as List<dynamic>),
      ),
    );
  }
}
