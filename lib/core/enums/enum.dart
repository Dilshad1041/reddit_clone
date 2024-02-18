enum ThemeMode { dark, light }

enum UserKarma {
  comment,
  textPost,
  linkPost,
  imagePost,
  awardPost,
  deletePost,
}

class KarmaValue {
  final int karma;

  const KarmaValue(this.karma);
}

Map<UserKarma, KarmaValue> userKarmaValues = {
  UserKarma.comment: KarmaValue(1),
  UserKarma.textPost: KarmaValue(2),
  UserKarma.linkPost: KarmaValue(3),
  UserKarma.imagePost: KarmaValue(3),
  UserKarma.awardPost: KarmaValue(5),
  UserKarma.deletePost: KarmaValue(-1),
};
