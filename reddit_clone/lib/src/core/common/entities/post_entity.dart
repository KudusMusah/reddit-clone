class PostEntity {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String? imageUrl;
  final String communityName;
  final String communityProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;

  PostEntity({
    required this.id,
    required this.title,
    this.link,
    this.description,
    this.imageUrl,
    required this.communityName,
    required this.communityProfilePic,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });
}
