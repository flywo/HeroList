import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../File/FileManager.dart';


class CustomWidget {
  //加载view
  static Widget buildLoadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const Text('加载中...'),
          ),
        ],
      ),
    );
  }

  //网络图片
  static Widget buildNetImage({double width, double height, BoxFit fit, String urlStr}) {
    final file = FileManager.getImgPath(urlStr);
    if (file!=null) {
      return Image(
          width: width,
          height: width,
          fit: fit,
          image: FileImage(file),
      );
    }
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: urlStr,
      placeholder: (BuildContext context, String url) {
        return const Icon(Icons.file_download, color: Colors.orange,);
      },
      errorWidget: (BuildContext context, String url, Object error) {
        return const Icon(Icons.error_outline);
      },
    );
  }
}
