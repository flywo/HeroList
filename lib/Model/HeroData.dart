
class HeroData {
  String href;
  String name;
  String number;
  String infoHref;
  List<HeroSkill> skills;
  List<HeroSkin> skins;
  List<HeroVideo> videos;

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

class HeroVideo {
  String href;
  String imgHref;
  String name;
  HeroVideo({this.href, this.imgHref, this.name});
}


class CommonSkill {
  String name;
  String href;
  String showImageHref;
  CommonSkill({this.name, this.href, this.showImageHref});
}