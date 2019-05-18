import 'package:dio/dio.dart';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../Model/HeroData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

typedef void ReloadDataHandle(List<HeroSkill> skills, List<HeroSkin> skins);
final MainUrl = 'https://pvp.qq.com/web201605/';
final dio = Dio(
    BaseOptions(
        contentType: ContentType.html,
        responseType: ResponseType.bytes
    )
);

Future<List<HeroData>> getMain() async {
  try {
    Response response = await dio.get(MainUrl+'herolist.shtml');
    print('获取到main结果，开始解析');
    final html = gbk.decode(response.data);
    return _parseHTML(html);
  } catch (e) {
    print('main发生了错误: '+e.toString());
  }
}

List<HeroData> _parseHTML(String html) {
  List<HeroData> list = [];
  final doc = parse(html);
  final heros = doc.getElementsByClassName("herolist clearfix").first;
  for (var item in heros.children) {
    final hero = _getHero(item);
    list.add(hero);
  }
  print('main解析完毕');
  return list;
}

HeroData _getHero(Element item) {
  final href = item.getElementsByTagName('img').first.attributes['src'];
  final name = item.getElementsByTagName('a').first.text;
  final infoHref = item.getElementsByTagName('a').first.attributes['href'];
  return HeroData(
    href: href,
    name: name,
    number: infoHref.substring(11, 14),
    infoHref: infoHref
  );
}




void getHeroInfo(HeroData hero, ReloadDataHandle handle) async {
  try {
    Response response = await dio.get(MainUrl+hero.infoHref);
    print('获取到info结果，开始解析');
    final doc = parse(gbk.decode(response.data));
    handle(
        _parseSkill(doc),
        _parseSkin(hero.number, doc)
    );
    print('info解析完毕');
  } catch (e) {
    print('info发生了错误: '+e.toString());
  }
}


List<HeroSkill> _parseSkill(Document doc) {
  final images = doc.getElementsByClassName("skill-u1").first;
  final details = doc.getElementsByClassName('skill-show').first;
  List<HeroSkill> list = [];
  for (var i=0; i<details.children.length; i++) {
    String image;
    final name = details.children[i].children[0].children[0].text;
    if (name==null || name.length==0) {
      continue;
    }
    final desc = details.children[i].children[1].text;
    final cooling = details.children[i].children[0].children[1].text;
    final expend = details.children[i].children[0].children[2].text;
    if (i==4) {
      image = images.children[i].attributes['data-img'];
    } else {
      image = images.children[i].children[0].attributes['src'];
    }
    final skill = HeroSkill(
      image: image,
      name: name,
      desc: desc,
      cooling: cooling,
      expend: expend
    );
    list.add(skill);
  }
  return list;
}

List<HeroSkin> _parseSkin(String heroNumber, Document doc) {
  final skinsStr = doc.getElementsByClassName('pic-pf-list pic-pf-list3').first.attributes['data-imgname'];
  final skins = skinsStr.split('|');
  List<HeroSkin> list = [];
  for (var i=skins.length-1; i>-1; i--) {
    final skin = HeroSkin(
      name: skins[i],
      href: '//game.gtimg.cn/images/yxzj/img201606/skin/hero-info/$heroNumber/$heroNumber-bigskin-${i+1}.jpg',
      smallHref: '//game.gtimg.cn/images/yxzj/img201606/heroimg/$heroNumber/$heroNumber-smallskin-${i+1}.jpg',
    );
    print('${skin.name}   ${skin.href}');
    list.add(skin);
  }
  return list;
}
