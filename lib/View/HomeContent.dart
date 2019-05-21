import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../View/AppComponent.dart';

typedef void TypeChoice(int type);

class HomeContent extends StatefulWidget {
  final bool openScreen;
  final TypeChoice choice;
  final int lastSelected;
  HomeContent({Key key, @required this.openScreen, @required this.choice, @required this.lastSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {

  List<HeroData> _heroList = [];
  List<HeroData> _heroList0 = [];
  List<HeroData> _heroList1 = [];
  List<HeroData> _heroList2 = [];
  List<HeroData> _heroList3 = [];
  List<HeroData> _heroList4 = [];
  List<HeroData> _heroList5 = [];
  List<HeroData> _heroList6 = [];
  List<HeroData> _heroList7 = [];
  List<HeroData> _heroList8 = [];

  @override
  void initState() {
    super.initState();
    if (AppComponent.articles == null) {
      final future = getArticle();
      future.then((value) {
        AppComponent.articles = value;
      });
    }
    if (AppComponent.heros != null) {
      _heroList0 = AppComponent.heros;
      tidyHeroList();
      _heroList = getHeros(widget.lastSelected);
      return;
    }
    final future = getMain();
    future.then((value) {
      _heroList0 = value;
      AppComponent.heros = _heroList0;
      tidyHeroList();
      setState(() {
        _heroList = _heroList0;
      });
    });
  }

  void tidyHeroList() {
    for (final item in _heroList0) {
      if (item.heroType==3||item.heroType2==3) {
        _heroList1.add(item);
      }
      if (item.heroType==1||item.heroType2==1) {
        _heroList2.add(item);
      }
      if (item.heroType==4||item.heroType2==4) {
        _heroList3.add(item);
      }
      if (item.heroType==2||item.heroType2==2) {
        _heroList4.add(item);
      }
      if (item.heroType==5||item.heroType2==5) {
        _heroList5.add(item);
      }
      if (item.heroType==6||item.heroType2==6) {
        _heroList6.add(item);
      }
      if (item.payType==10) {
        _heroList7.add(item);
      }
      if (item.payType==11) {
        _heroList8.add(item);
      }
    }
  }

  List<HeroData> getHeros(int type) {
    List<HeroData> result = [];
    switch (type) {
      case 0:
        result = _heroList0;
        break;
      case 1:
        result = _heroList1;
        break;
      case 2:
        result = _heroList2;
        break;
      case 3:
        result = _heroList3;
        break;
      case 4:
        result = _heroList4;
        break;
      case 5:
        result = _heroList5;
        break;
      case 6:
        result = _heroList6;
        break;
      case 7:
        result = _heroList7;
        break;
      case 8:
        result = _heroList8;
        break;
    }
    return result;
  }

  Widget _getItem(double width, int index, HeroData hero) {
    return GestureDetector(
      onTap: () {
        Application.router.navigateTo(
            context,
            Uri.encodeFull('/hero_info?heroIndex=${_heroList0.indexOf(getHeros(widget.lastSelected)[index])}'),
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
                return const Icon(Icons.file_download, color: Colors.orange,);
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return const Icon(Icons.error_outline);
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
          const CircularProgressIndicator(),
          const Padding(
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

    RadioListTile<int> _buildTil(int value, Widget title) {
      return RadioListTile<int>(
        value: value,
        title: title,
        groupValue: widget.lastSelected,
        onChanged: (value) {
          widget.choice(value);
          setState(() {
            _heroList = getHeros(value);
          });
        },
      );
    }

    if (widget.openScreen) {
      return Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildTil(0, const Text('所有')),
              _buildTil(1, const Text('坦克')),
              _buildTil(2, const Text('战士')),
              _buildTil(3, const Text('刺客')),
              _buildTil(4, const Text('法师')),
              _buildTil(5, const Text('射手')),
              _buildTil(6, const Text('辅助')),
              _buildTil(7, const Text('本周免费')),
              _buildTil(8, const Text('新手推荐')),
            ],
          ),
        ],
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(5),
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