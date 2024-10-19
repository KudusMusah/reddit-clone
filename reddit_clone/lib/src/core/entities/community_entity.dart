class CommunityEntity {
  final String id;
  final String name;
  final String banner;
  final String profileImage;
  final List<String> members;
  final List<String> mods;
  CommunityEntity({
    required this.id,
    required this.name,
    required this.banner,
    required this.profileImage,
    required this.members,
    required this.mods,
  });
}
