import 'package:dio/dio.dart';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../Model/HeroData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

typedef void ReloadDataHandle(String backImageUr, List<HeroSkill> skills);
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
    infoHref: infoHref
  );
}




void getHeroInfo(HeroData hero, ReloadDataHandle handle) async {
  try {
    Response response = await dio.get(MainUrl+hero.infoHref);
    print('获取到info结果，开始解析');
    final doc = parse(gbk.decode(response.data));
    handle(
        _parseBIInfo(doc),
        _parseSkill(doc)
    );
    print('info解析完毕');
  } catch (e) {
    print('info发生了错误: '+e.toString());
  }
}

String _parseBIInfo(Document doc) {
  final backImageUrl = doc.getElementsByClassName("zk-con1 zk-con").first.attributes['style'];
  final exp = RegExp(r'//.*jpg');
  return exp.stringMatch(backImageUrl);
}

List<HeroSkill> _parseSkill(Document doc) {
  final images = doc.getElementsByClassName("skill-u1").first;
  final details = doc.getElementsByClassName('skill-show').first;
  List<HeroSkill> list = [];
  for (var i=0; i<details.children.length; i++) {
    String image;
    final name = details.children[i].children[0].children[0].text;
    final desc = details.children[i].children[1].text;
    if (i==4) {
      image = images.children[i].attributes['data-img'];
    } else {
      image = images.children[i].children[0].attributes['src'];
    }
    if (name==null || name.length==0) {
      continue;
    }
    final skill = HeroSkill(
      image: image,
      name: name,
      desc: desc
    );
    list.add(skill);
  }
  return list;
}
