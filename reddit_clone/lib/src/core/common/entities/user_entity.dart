class UserEntity {
  final String uid;
  final String name;
  final String profilePic;
  final String banner;
  final int karma;
  final List<String> awards;
  final bool isAuthenticated;

  UserEntity({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.karma,
    required this.awards,
    required this.isAuthenticated,
  });
}
