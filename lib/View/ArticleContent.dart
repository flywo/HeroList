import 'package:flutter/material.dart';
import '../Model/ArticleData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Net/Net.dart';
import '../CustomWidget/LoadingDialog.dart';
import '../View/AppComponent.dart';


class ArticleContent extends StatefulWidget {
  ArticleContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ArticleContentState();
  }
}

class _ArticleContentState extends State<ArticleContent> {

  List<ArticleData> _articleList = [];

  @override
  void initState() {
    super.initState();
    if (AppComponent.articles != null) {
      _articleList = AppComponent.articles;
      return;
    }
    final future = getArticle();
    future.then((value) {
      setState(() {
        _articleList = value;
        AppComponent.articles = value;
      });
    });
  }

  Widget _getItem(double width, int index, ArticleData article) {
    return GestureDetector(
      onTap: () {
        showDetail(_articleList[index]);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: CachedNetworkImage(
              width: width,
              height: width,
              fit: BoxFit.fill,
              imageUrl: 'https:${article.href}',
              placeholder: (BuildContext context, String url) {
                return const Icon(Icons.file_download, color: Colors.orange,);
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return const Icon(Icons.error_outline);
              },
            ),
          ),
          Text(article.name),
        ],
      ),
    );
  }

  Widget loading() {
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

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-40)/4;
    final aspect = width/(width+20);
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: _articleList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getItem(width, index, _articleList[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: aspect
      ),
    );
  }

  void showDetail(ArticleData aritcle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArticleDialog(article: aritcle);
      });
  }

  @override
  Widget build(BuildContext context) {
    return _articleList.length==0?loading():listView();
  }
}