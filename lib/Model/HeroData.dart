


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
  //免费标志
  int payType;
  //英雄定位
  int heroType;
  //新手推荐
  int newType;
  //定位2
  int heroType2;
  //技能
  List<HeroSkill> skills;
  //皮肤
  List<HeroSkin> skins;

  //对应表
  static const Map<String, String> mapVlue = {
  '194': '1625',
  '198': '1626',
  '187': '835',
  '149': '836',
  '175': '837',
  '171': '838',
  '113': '839',
  '168': '840',
  '108': '841',
  '114': '842',
  '105': '843',
  '120': '844',
  '135': '845',
  '144': '847',
  '193': '1285',
  '180': '849',
  '178': '850',
  '163': '851',
  '183': '852',
  '126': '853',
  '140': '854',
  '123': '855',
  '134': '856',
  '139': '858',
  '129': '859',
  '128': '860',
  '166': '861',
  '167': '862',
  '117': '863',
  '107': '864',
  '130': '928',
  '170': '929',
  '179': '1629',
  '182': '865',
  '190': '866',
  '157': '867',
  '141': '868',
  '121': '869',
  '156': '870',
  '142': '871',
  '109': '872',
  '119': '873',
  '152': '874',
  '115': '875',
  '136': '876',
  '106': '877',
  '124': '878',
  '127': '879',
  '148': '880',
  '110': '881',
  '196': '1295',
  '199': '1654',
  '192': '882',
  '177': '883',
  '132': '884',
  '174': '885',
  '173': '886',
  '112': '889',
  '111': '890',
  '133': '891',
  '169': '892',
  '189': '1199',
  '501': '1636',
  '176': '1754',
  '191': '893',
  '186': '894',
  '184': '895',
  '118': '896',
  '195': '1368',
  '131': '897',
  '162': '898',
  '153': '899',
  '154': '900',
  '150': '901',
  '146': '902',
  '116': '903',
  '502': '1755',
  '197': '1823',
  '503': '1858',
  '504': '1856',
  '125': '2568',
  '510': '2569',
  '137': '2604',
  '509': '2607',
  '508': '2623',
  '312':'2639',
  '507': '2646',
  '513': '2647',
  '515': '2656',
  '511': '2657',
  '529': '2673',
  '505': '2924',
  '506': '2934'
  };

  HeroData({this.href, this.name, this.infoHref, this.number, this.payType, this.heroType, this.newType, this.heroType2});
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

//召唤师技能
class CommonSkill {
  //名称
  String name;
  //小图url
  String href;
  //大图url
  String showImageHref;
  //技能ID
  String iD;
  //解锁时间
  String rank;
  //描述
  String description;
  CommonSkill({this.name, this.href, this.showImageHref, this.iD, this.rank, this.description});
}