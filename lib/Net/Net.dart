import 'package:dio/dio.dart';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../Model/HeroData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import '../Model/ArticleData.dart';
import 'dart:convert';

typedef void ReloadDataHandle(List<HeroSkill> skills, List<HeroSkin> skins);
final MainUrl = 'https://pvp.qq.com/web201605/';
final dio = Dio(
    BaseOptions(
        contentType: ContentType.html,
        responseType: ResponseType.bytes
    )
);

//获取英雄列表页
Future<List<HeroData>> getMain() async {
  try {
    Response response = await dio.get(MainUrl+'herolist.shtml');
    print('获取到main结果，开始解析');
    final html = await gbk.decode(response.data);
    return await _parseHTML(html);
  } catch (e) {
    print('main发生了错误: '+e.toString());
  }
}
//解析英雄列表
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
//解析单个英雄
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



//获取英雄信息页
void getHeroInfo(HeroData hero, ReloadDataHandle handle) async {
  try {
    Response response = await dio.get(MainUrl+hero.infoHref);
    print('获取到info结果，开始解析');
    final doc = await parse(gbk.decode(response.data));
    handle(
        await _parseSkill(doc),
        await _parseSkin(hero.number, doc)
    );
    print('info解析完毕');
  } catch (e) {
    print('info发生了错误: '+e.toString());
  }
}
//解析技能
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
//解析皮肤
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
    list.add(skin);
  }
  return list;
}



//获取物品页面
Future<List<ArticleData>> getArticle() async {
  try {
    Response response = await dio.get(MainUrl+'item.shtml');
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get('https://pvp.qq.com/web201605/js/item.json');
    print('获取到article结果，开始解析');
    final html = await gbk.decode(response.data);
    return await _parseArticles(html, detailJson.toString());
  } catch (e) {
    print('article发生了错误: '+e.toString());
  }
}
List<ArticleData> _parseArticles(String html, String json) {
  List<ArticleData> list = [];
  final doc = parse(html);
  final items = doc.getElementsByClassName('clearfix herolist').first;
  final itemDetails = jsonDecode(json);
  Map<String, dynamic> map = {};
  for (final item in itemDetails) {
    map[item['item_id'].toString()] = item;
  }
  for (final item in items.children) {
    list.add(_parseArticle(item, map));
  }
  return list;
}
ArticleData _parseArticle(Element item, Map<String, dynamic> map) {
  final href = item.children[0].children[0].attributes['src'];
  final name = item.children[0].text;
  final ID = item.children[0].attributes['data-href'].split('.').first;
  final data = map[ID];
  return ArticleData(
    href: href,
    name: name,
    ID: ID,
    type: data['item_type'].toString(),
    sellPrice: data['price'].toString(),
    buyPrice: data['total_price'].toString(),
    desc1: data['des1'].toString(),
    desc2: data['des2']==null?'':data['des2']
  );
}



//获得视频列表
Future<List<HeroVideo>> getVideos(String heroNmae) async {
  try {
    Response response = await dio.get('http://so.iqiyi.com/so/q_王者荣耀${heroNmae}?source=input&sr=1106277143580');
    print('获取到video结果，开始解析');
    final html = utf8.decode(response.data);
    return await _parseVideoHTML(html);
  } catch (e) {
    print('video发生了错误: '+e.toString());
  }
}
List<HeroVideo> _parseVideoHTML(String html) {
  List<HeroVideo> videos = [];
  final list = parse(html).getElementsByClassName('mod_result_list').first.children;
  for (final item in list) {
    final name = item.attributes['data-widget-searchlist-tvname'];
    if (name==null||name.length==0) {
      continue;
    }
    final imgHref = item.children[0].children[0].attributes['src'];
    //视频地址太难抓，算了，写个固定的。
    final href = 'http://ips.ifeng.com/video19.ifeng.com/video09/2018/12/14/p6060124-102-009-123437.mp4';
    var video = HeroVideo(
      href: href,
      imgHref: imgHref,
      name: name
    );
    videos.add(video);
  }
  return videos;
}


