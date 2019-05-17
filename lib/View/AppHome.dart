import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AppHome extends StatefulWidget {
  AppHome({Key key}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppHomeState();
  }
}

class _AppHomeState extends State<AppHome> {
  
//  var _itemWidth = (MediaQueryData.fromWindow(window).size.width - 40)/3;
//  var _itemWidth = (GlobalKey().currentContext.size.width - 40)/3;

  List<HeroData> _heroList = [];

  Widget _getItem(double width, int index, HeroData hero) {
    return GestureDetector(
      onTap: () {
        Application.router.navigateTo(
          context,
          Uri.encodeFull('/hero_info?href=${hero.href.replaceAll('/', '`')}&name=${hero.name}&infoHref=${hero.infoHref.replaceAll('/', '`')}'),
          transition: TransitionType.native
        );
      },
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            width: width,
            height: width,
            imageUrl: 'https:${hero.href}',
            placeholder: (BuildContext context, String url) {
              return CircularProgressIndicator();
            },
            errorWidget: (BuildContext context, String url, Object error) {
              return Icon(Icons.error_outline);
            },
          ),
          Text(hero.name),
        ],
      ),
    );
  }

  @override
  void initState() {
    final future = getMain();
    future.then((value) {
      setState(() {
        _heroList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width-40)/4;
    final aspect = width/(width+20);
    return Scaffold(
        appBar: AppBar(
          title: Text('英雄列表', style: TextStyle(color: Colors.white),),
        ),
        body: GridView.builder(
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
        )
    );
  }
}