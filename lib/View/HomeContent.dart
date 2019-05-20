import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../View/AppComponent.dart';


class HomeContent extends StatefulWidget {
  HomeContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {

  List<HeroData> _heroList = [];

  @override
  void initState() {
    if (AppComponent.articles == null) {
      final future = getArticle();
      future.then((value) {
        AppComponent.articles = value;
      });
    }
    if (AppComponent.heros != null) {
      _heroList = AppComponent.heros;
      return;
    }
    final future = getMain();
    future.then((value) {
      setState(() {
        _heroList = value;
        AppComponent.heros = value;
      });
    });
  }

  Widget _getItem(double width, int index, HeroData hero) {
    return GestureDetector(
      onTap: () {
        Application.router.navigateTo(
            context,
            Uri.encodeFull('/hero_info?heroIndex=$index'),
            transition: TransitionType.native
        );
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
              imageUrl: 'https:${hero.href}',
              placeholder: (BuildContext context, String url) {
                return CircularProgressIndicator();
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return Icon(Icons.error_outline);
              },
            ),
          ),
          Text(hero.name),
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
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('加载中...'),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-40)/4;
    final aspect = width/(width+20);
    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: _heroList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getItem(width, index, _heroList[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: aspect
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _heroList.length==0? loading() : listView();
  }
}