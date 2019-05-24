import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';
import 'package:sqflite/sqflite.dart';


class FileManager {

  static String docPath;
  static Map<String, File> _urlMap = {};

  //移动资源到存储
  static Future<bool> moveAssetToStored() async {
    if (_urlMap.length!=0) {
      print('无需再次获取_urlMap');
      return false;
    }
    return await getApplicationDocumentsDirectory().then((value) {
      docPath = value.path;
      final file = File('${value.path}/assets.zip');
      if (!file.existsSync()) {
        print('移动数据到存储中');
        return file.create().then((file) {
          return rootBundle.load('assets/wzry_data.zip').then((data) {
            file.writeAsBytesSync(data.buffer.asInt8List(0));
            return _zipAssets();
          });
        });
      } else {
        print('数据已存在');
        return _zipAssets();
      }
    });
  }
  //解压资源
  static Future<bool> _zipAssets() async {
    final dic = Directory('$docPath/assets_data');
    if (dic.existsSync()) {
      print('zip已解压');
    } else {
      dic.createSync();
      List<int> bytes = File('$docPath/assets.zip').readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(bytes);
      for (ArchiveFile file in archive) {
        String filename = file.name;
        if (file.isFile) {
          List<int> data = file.content;
          File('$docPath/assets_data/' + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('$docPath/assets_data/' + filename)
            ..createSync(recursive: true);
        }
      }
      print('zip解压完毕');
    }
    return await _initUrlMap();
  }
  //初始化urlmap
  static Future<bool> _initUrlMap() async {
    if (File('$docPath/assets_data/wzry_data/libCachedImageData.db').existsSync()) {
      final db = await openDatabase('$docPath/assets_data/wzry_data/libCachedImageData.db');
      List<Map<String, dynamic>> result = await db.rawQuery('SELECT url,relativePath FROM cacheObject');
      for (final item in result) {
        _urlMap[item['url']] = File('$docPath/assets_data/wzry_data/libCachedImageData/${item['relativePath']}');
      }
      print(_urlMap.length);
      db.close();
      print('解析数据库完毕');
      return true;
    } else {
      print('数据库不存在了！');
      return false;
    }
  }

  //获得图片，不存在则返回原url
  static File getImgPath(String url) {
    return _urlMap[url];
  }

  //获取缓存的json数据
  static Future<String> getCacheJsonData(String file) async {
    return await rootBundle.loadString('$docPath/assets_data/wzry_data/$file');
  }

  //写入缓存
  static void saveCacheJsonData(String name, String content) async {
    try {
      final file = await File('$docPath/assets_data/wzry_data/$name');
      file.writeAsString(content).then((value) {
        print('写入文件结果:$value}');
      });
    } catch (e) {
      print('写入文件发生错误:${e.toString()}');
    }
  }
}