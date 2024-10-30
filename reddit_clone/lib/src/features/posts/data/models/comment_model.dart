import 'package:reddit_clone/src/features/posts/domain/entities/comments.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.text,
    required super.createdAt,
    required super.postId,
    required super.username,
    required super.profilePic,
  });

  CommentModel copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
  }) {
    return CommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  @override
  String toString() {
    return 'CommentEntity(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic)';
  }
}
