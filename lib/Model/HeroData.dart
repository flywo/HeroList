
class HeroData {
  String href;
  String name;
  String backImageUrl;
  String infoHref;
  List<HeroSkill> skills;

  HeroData({this.href, this.name, this.infoHref});
}

class HeroSkill {
  String image;
  String name;
  String desc;
  HeroSkill({this.image, this.name, this.desc});
}