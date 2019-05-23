import 'package:dio/dio.dart';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../Model/HeroData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import '../Model/ArticleData.dart';
import 'dart:convert';
import '../Model/MingData.dart';


typedef void ReloadDataHandle(List<HeroSkill> skills, List<HeroSkin> skins, List<String> recommond);
const MainUrl = 'https://pvp.qq.com/web201605/';
const HeroList = 'js/herolist.json';
const SummonerList = 'js/summoner.json';
const ItemList = 'js/item.json';
const MingList = 'js/ming.json';


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
    Response response = await Dio(
        BaseOptions(
            contentType: ContentType.html,
            responseType: ResponseType.bytes
        )
    ).get(MainUrl+hero.infoHref);
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
      iD: item['item_id'].toString(),
      sellPrice: item['total_price'].toString(),
      buyPrice: item['total_price'].toString(),
      desc1: item['des1'],
      desc2: item['des2'],
      type: item['item_type'],
    ));
  }
  return list;
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
      iD: item['summoner_id'].toString(),
      rank: item['summoner_rank'],
      description: item['summoner_description'],
      showImageHref: "//game.gtimg.cn/images/yxzj/img201606/summoner/${item['summoner_id']}-big.jpg"
    ));
  }
  return result;
}


//获得符文列表
Future<List<MingData>> getMings() async {
  try {
    Response detailJson = await Dio(BaseOptions(contentType: ContentType.json, responseType: ResponseType.json)).get(MainUrl+MingList);
    print('获取到skill结果，开始解析');
    return await _parseMingHtml(detailJson.toString());
  } catch (e) {
    print('skill发生了错误: '+e.toString());
    return null;
  }
}
Future<List<MingData>> _parseMingHtml(String json) async {
  List<MingData> result = [];
  final details = jsonDecode(json);
  for (final item in details) {
    result.add(MingData(
      mingID: item['ming_id'],
      type: item['ming_type'],
      grade: item['ming_grade'],
      name: item['ming_name'],
      des: item['ming_des'],
      href: "//game.gtimg.cn/images/yxzj/img201606/mingwen/${item['ming_id']}.png"
    ));
  }
  return result;
}



//获得所有新手视频信息
Future<Map<String, dynamic>> getNewVideos() async {
  try {
    Response response = await Dio(
        BaseOptions(
            contentType: ContentType.html,
            responseType: ResponseType.plain
        )
    ).get('https://gicp.qq.com/wmp/data/js/v3/WMP_PVP_WEBSITE_NEWBEE_DATA_V1.js');
    print('获取到video结果，开始解析');
    return await _parseNewVideoHTML(response.toString());
  } catch (e) {
    print('video发生了错误: '+e.toString());
    return null;
  }
}
Future<Map<String, dynamic>> _parseNewVideoHTML(String html) async {
  final re = RegExp(r'{.*}');
  final result = jsonDecode(re.stringMatch(html));
  return result['video'] as Map<String, dynamic>;
}
Future<Map<String, dynamic>> getUpVideos() async {
  try {
    Response response = await Dio(
        BaseOptions(
            contentType: ContentType.html,
            responseType: ResponseType.plain
        )
    ).get('https://gicp.qq.com/wmp/data/js/v3/WMP_PVP_WEBSITE_DATA_18_VIDEO_V3.js');
    return _parseUpVideoHTML(response.toString());
  } catch (e) {
    print('video发生了错误: '+e.toString());
    return null;
  }
}
Future<Map<String, dynamic>> _parseUpVideoHTML(String html) async {
  final re = RegExp(r'{.*}');
  return jsonDecode(re.stringMatch(html)) as Map<String, dynamic>;
}
//查询视频信息
Future<String> queryVideoInfo(String vID) async {
  try {
    Response response = await Dio(
        BaseOptions(
            contentType: ContentType.html,
            responseType: ResponseType.plain)
    ).post(
        'https://apps.game.qq.com/wmp/v3.1/public/search.php',
        queryParameters: {'source':'pvpweb_detail','id':vID,'p0':18},);
    print('开始解析video');
    return await _getVID(response.toString());
  } catch (e) {
    print('解析video信息发生错误:${e.toString()}');
    return null;
  }
}
Future<String> _getVID(String str) async {
  final re = RegExp(r'"sVID":"[0-9a-zA-Z]{11}"');
  return await _getVideoUrl(re.stringMatch(str).substring(8, 19));
}
Future<String> _getVideoUrl(String vID) async {
  Response response = await Dio(
      BaseOptions(
          contentType: ContentType.html,
          responseType: ResponseType.plain)
  ).post(
    'https://h5vv.video.qq.com/getinfo',
    queryParameters: {'vids':vID,'otype':'json','ehost':'https://pvp.qq.com','platform':11001,'sdtfrom':'v1010'},);
  return _getVideoURL(response.toString(), vID);
}
String _getVideoURL(String response, String vID) {
  final re = RegExp(r'{.*}');
  final json = jsonDecode(re.stringMatch(response));
  final url = json['vl']['vi'][0]['ul']['ui'][0]['url'];
  final name = json['vl']['vi'][0]['fn'];
  final key = json['vl']['vi'][0]['fvkey'];
  return url+name+'?vkey='+key;
}