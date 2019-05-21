import 'package:dio/dio.dart';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../Model/HeroData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import '../Model/ArticleData.dart';
import 'dart:convert';

typedef void ReloadDataHandle(List<HeroSkill> skills, List<HeroSkin> skins, List<String> recommond);
const MainUrl = 'https://pvp.qq.com/web201605/';
const HeroList = 'js/herolist.json';
const SummonerList = 'js/summoner.json';
const ItemList = 'js/item.json';

final dio = Dio(
    BaseOptions(
        contentType: ContentType.html,
        responseType: ResponseType.bytes
    )
);

//获取英雄列表页
Future<List<HeroData>> getMain() async {
  try {
    Response response = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+HeroList);
    print('获取到main结果，开始解析');
    return await _parseHTML(response.toString());
  } catch (e) {
    print('main发生了错误: '+e.toString());
    return null;
  }
}
//解析英雄列表
Future<List<HeroData>> _parseHTML(String json) async {
  List<HeroData> list = [];
  final heros = jsonDecode(json) as List<dynamic>;
  for (var i=heros.length-1; i>-1; i-- ) {
    final item = heros[i];
    list.add(HeroData(
      href: "//game.gtimg.cn/images/yxzj/img201606/heroimg/${item['ename']}/${item['ename']}.jpg",
      name: item['cname'],
      number: item['ename'].toString(),
      infoHref: "herodetail/${item['ename']}.shtml",
      payType: item['pay_type'],
      heroType: item['hero_type'],
      newType: item['new_type'],
      heroType2: item['hero_type2']
    ));
  }
  print('main解析完毕');
  return list;
}



//获取英雄信息页
void getHeroInfo(HeroData hero, ReloadDataHandle handle) async {
  try {
    Response response = await dio.get(MainUrl+hero.infoHref);
    print('获取到info结果，开始解析');
    final doc = parse(gbk.decode(response.data));
    handle(
        await _parseSkill(doc),
        await _parseSkin(hero.number, doc),
        await _parseRecommend(doc),
    );
    print('info解析完毕');
  } catch (e) {
    print('info发生了错误: '+e.toString());
  }
}
//解析技能
Future<List<HeroSkill>> _parseSkill(Document doc) async {
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
Future<List<HeroSkin>> _parseSkin(String heroNumber, Document doc) async {
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
//解析出装
Future<List<String>> _parseRecommend(Document doc) async {
  final recommends = doc.getElementsByClassName('equip-bd').first;
  final recommend1 = recommends.children[0].children[0].attributes['data-item'];
  final recommend2 = recommends.children[1].children[0].attributes['data-item'];
  final recommend1desc = recommends.children[0].children[1].text;
  final recommend2desc = recommends.children[1].children[1].text;
  return [recommend1, recommend1desc, recommend2, recommend2desc];
}


//获取物品页面
Future<List<ArticleData>> getArticle() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+ItemList);
    print('获取到article结果，开始解析');
    return await _parseArticles(detailJson.toString());
  } catch (e) {
    print('article发生了错误: '+e.toString());
    return null;
  }
}
Future<List<ArticleData>> _parseArticles(String json) async {
  List<ArticleData> list = [];
  final itemDetails = jsonDecode(json);
  for (final item in itemDetails) {
    list.add(ArticleData(
      href: "//game.gtimg.cn/images/yxzj/img201606/itemimg/${item['item_id']}.jpg",
      name: item['item_name'],
      ID: item['item_id'].toString(),
      sellPrice: item['total_price'].toString(),
      buyPrice: item['total_price'].toString(),
      desc1: item['des1'],
      desc2: item['des2']
    ));
  }
  return list;
}


//获得视频列表
Future<List<HeroVideo>> getVideos(String heroNmae) async {
  try {
    Response response = await dio.get('http://so.iqiyi.com/so/q_王者荣耀$heroNmae?source=input&sr=1106277143580');
    print('获取到video结果，开始解析');
    final html = utf8.decode(response.data);
    return await _parseVideoHTML(html);
  } catch (e) {
    print('video发生了错误: '+e.toString());
    return null;
  }
}
Future<List<HeroVideo>> _parseVideoHTML(String html) async {
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




//获得召唤师技能
Future<List<CommonSkill>> getCommonSkill() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+SummonerList);
    print('获取到skill结果，开始解析');
    return await _parseCommonHtml(detailJson.toString());
  } catch (e) {
    print('skill发生了错误: '+e.toString());
    return null;
  }
}
Future<List<CommonSkill>> _parseCommonHtml(String json) async {
  List<CommonSkill> result = [];
  final details = jsonDecode(json);
  for (final item in details) {
    result.add(CommonSkill(
      name: item['summoner_name'],
      href: "//game.gtimg.cn/images/yxzj/img201606/summoner/${item['summoner_id']}.jpg",
      ID: item['summoner_id'].toString(),
      rank: item['summoner_rank'],
      description: item['summoner_description'],
      showImageHref: "//game.gtimg.cn/images/yxzj/img201606/summoner/${item['summoner_id']}-big.jpg"
    ));
  }
  return result;
}

