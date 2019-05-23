import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';
import 'package:sqflite/sqflite.dart';


class FileManager {

  static String DocPath;
  static Map<String, String> _urlMap = {};

  //移动资源到存储
  static void moveAssetToStored() async {
    getApplicationDocumentsDirectory().then((value) {
      DocPath = value.path;
      final file = File('${value.path}/assets.zip');
      if (!file.existsSync()) {
        print('移动数据到存储中');
        file.create().then((file) {
          rootBundle.load('assets/wzry_data.zip').then((data) {
            file.writeAsBytesSync(data.buffer.asInt8List(0));
            _zipAssets();
          });
        });
      } else {
        print('数据已存在');
        _zipAssets();
      }
    });
  }
  //解压资源
  static void _zipAssets() async {
    final dic = Directory('${DocPath}/assets_data');
    if (dic.existsSync()) {
      print('zip已解压');
      _initUrlMap();
    } else {
      dic.createSync();
      List<int> bytes = File('${DocPath}/assets.zip').readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(bytes);
      for (ArchiveFile file in archive) {
        String filename = file.name;
        if (file.isFile) {
          List<int> data = file.content;
          File('${DocPath}/assets_data/' + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('${DocPath}/assets_data/' + filename)
            ..createSync(recursive: true);
        }
      }
      print('zip解压完毕');
      _initUrlMap();
    }
  }
  //初始化urlmap
  static void _initUrlMap() async {
    if (File('${DocPath}/assets_data/wzry_data/libCachedImageData.db').existsSync()) {
      final db = await openDatabase('${DocPath}/assets_data/wzry_data/libCachedImageData.db');
      List<Map<String, dynamic>> result = await db.rawQuery('SELECT url,relativePath FROM cacheObject');
      for (final item in result) {
        _urlMap[item['url']] = item['relativePath'];
      }
      print(_urlMap.length);
      db.close();
      print('解析数据库完毕');
    } else {
      print('数据库不存在了！');
    }
  }
  //获得图片路径，不存在则返回原url
  static String getImgPath(String url) {
    if (_urlMap[url]==null) {
      return url;
    } else {
      return '${DocPath}/assets_data/wzry_data/libCachedImageData/${_urlMap[url]}';
    }
  }
}