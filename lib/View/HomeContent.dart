import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import '../View/AppComponent.dart';
import '../CustomWidget/CustomWidget.dart';
import '../File/FileManager.dart';


typedef void TypeChoice(int type);

class HomeContent extends StatefulWidget {
  HomeContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {

  int _selected = 0;
  List<HeroData> _heros = [];
  bool _showChoice = false;

  @override
  void initState() {
    super.initState();
    FileManager.moveAssetToStored();
    if (AppComponent.videos == null) {
      getNewVideos().then((value) {
        AppComponent.videos = value;
      });
    }
    if (AppComponent.videos2 == null) {
      getUpVideos().then((value) {
        AppComponent.videos2 = value;
      });
    }
    if (AppComponent.heros == null) {
      final future = getMain();
      future.then((value) {
        AppComponent.heros = value;
        setState(() {
          _heros = value;
        });
      });
    } else {
      _heros = AppComponent.heros;
    }
    if (AppComponent.articles == null) {
      final future = getArticle();
      future.then((value) {
        AppComponent.articles = value;
      });
    }
    if (AppComponent.mings == null) {
      getMings().then((value) {
        AppComponent.mings = value;
      });
    }
  }

  void _tidyHeroList() {
    if (_selected==0) {
      setState(() {
        _heros = AppComponent.heros;
      });
      return;
    }
    List<HeroData> result = [];
    for (final item in AppComponent.heros) {
      if (_selected>=10) {
        if (item.payType==_selected) {
          result.add(item);
        }
      } else {
        if (item.heroType==_selected||item.heroType2==_selected) {
          result.add(item);
        }
      }
    }
    setState(() {
      _heros = result;
    });
  }

  Widget _getItem(double width, HeroData hero) {
    return GestureDetector(
      onTap: () {
        Application.router.navigateTo(
            context,
            Uri.encodeFull('/hero_info?heroIndex=${AppComponent.heros.indexOf(hero)}'),
            transition: TransitionType.native
        );
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: CustomWidget.buildNetImage(
              width: width,
              height: width,
              fit: BoxFit.fill,
              urlStr: 'https:${hero.href}'
            ),
          ),
          Text(hero.name, style: const TextStyle(fontSize: 12),),
        ],
      ),
    );
  }
  
  Widget _choiceItem(int value, Text text) {
    return Column(
      children: <Widget>[
        Radio<int>(
          groupValue: _selected,
          value: value,
          onChanged: (value) {
            _selected = value;
            _tidyHeroList();
          },
        ),
        text
      ],
    );
  }

  Widget _buildChoiceView() {
    if (!_showChoice) {
      return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          child: const Text('点击筛选英雄', style: TextStyle(color: Colors.orange),),
          onPressed: () {
            setState(() {
              _showChoice = true;
            });
          },
        ),
      );
    }
    return SizedBox(
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      child: const Text('综合', style: TextStyle(fontSize: 18, color: Colors.orange), textAlign: TextAlign.center,),
                    ),
                    _choiceItem(0, Text('全部')),
                    _choiceItem(10, const Text('限免')),
                    _choiceItem(11, const Text('新手')),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 70,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up, color: Colors.orange,),
                  onPressed: () {
                    setState(() {
                      _showChoice = false;
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: const Text('定位', style: TextStyle(fontSize: 18, color: Colors.orange), textAlign: TextAlign.center,),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-60,
                  height: 70,
                  child: Scrollbar(
                    child: ListView(
                      itemExtent: 60,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _choiceItem(3, const Text('坦克')),
                        _choiceItem(1, const Text('战士')),
                        _choiceItem(4, const Text('刺客')),
                        _choiceItem(2, const Text('法师')),
                        _choiceItem(5, const Text('射手')),
                        _choiceItem(6, const Text('辅助')),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-40)/4;
    final aspect = width/(width+20);

    return Column(
      children: <Widget>[
        _buildChoiceView(),
        Expanded(
          child: Scrollbar(
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              itemCount: _heros.length,
              itemBuilder: (BuildContext context, int index) {
                return _getItem(width, _heros[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: aspect
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _heros.length==0? CustomWidget.buildLoadingView() : listView();
  }
}