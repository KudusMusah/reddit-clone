enum UserKarma {
  comment(1),
  linkPost(2),
  textPost(3),
  imagePost(3),
  deletePost(-1),
  awardPost(5);

  final int karma;
  const UserKarma(this.karma);
}
