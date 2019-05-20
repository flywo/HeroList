
//英雄
class HeroData {
  //英雄头像url
  String href;
  //英雄名称
  String name;
  //英雄编号
  String number;
  //信息页url尾
  String infoHref;
  //推荐出装1
  String recommend1;
  //出装1描述
  String recommend1desc;
  //推荐出装2
  String recommend2;
  //出装2描述
  String recommend2desc;
  //技能
  List<HeroSkill> skills;
  //皮肤
  List<HeroSkin> skins;
  //视频
  List<HeroVideo> videos;

  HeroData({this.href, this.name, this.infoHref, this.number});
}

//技能
class HeroSkin {
  //名称
  String name;
  //图片url
  String href;
  //技能编号
  String smallHref;
  HeroSkin({this.name, this.href, this.smallHref});
}

//皮肤
class HeroSkill {
  //图片
  String image;
  //名称
  String name;
  //冷却
  String cooling;
  //消耗
  String expend;
  //描述
  String desc;
  HeroSkill({this.image, this.name, this.desc, this.cooling, this.expend});
}

//英雄视频
class HeroVideo {
  //视频链接
  String href;
  //预览图片
  String imgHref;
  //名称
  String name;
  HeroVideo({this.href, this.imgHref, this.name});
}

//召唤师技能
class CommonSkill {
  //名称
  String name;
  //小图url
  String href;
  //大图url
  String showImageHref;
  //技能ID
  String ID;
  //解锁时间
  String rank;
  //描述
  String description;
  CommonSkill({this.name, this.href, this.showImageHref, this.ID, this.rank, this.description});
}