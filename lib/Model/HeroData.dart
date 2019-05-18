
class HeroData {
  String href;
  String name;
  String number;
  String infoHref;
  List<HeroSkill> skills;
  List<HeroSkin> skins;

  HeroData({this.href, this.name, this.infoHref, this.number});
}

class HeroSkin {
  String name;
  String href;
  String smallHref;
  HeroSkin({this.name, this.href, this.smallHref});
}

class HeroSkill {
  String image;
  String name;
  String cooling;
  String expend;
  String desc;
  HeroSkill({this.image, this.name, this.desc, this.cooling, this.expend});
}