import 'package:flutter/material.dart';
import '../View/HomeContent.dart';
import '../View/ArticleContent.dart';
import '../View/CommonContent.dart';


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

  int _currentTabbarIndex = 0;

  Widget _getCurrentContent() {
    Widget result;
    switch (_currentTabbarIndex) {
      case 0:
        result = HomeContent();
        break;
      case 1:
        result = ArticleContent();
        break;
      case 2:
        result = CommonContent();
        break;
    }
    return result;
  }

  String _getCurrentTitle() {
    String result;
    switch (_currentTabbarIndex) {
      case 0:
        result = "英雄列表";
        break;
      case 1:
        result = "物品列表";
        break;
      case 2:
        result = "召唤师技能";
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_getCurrentTitle(), style: TextStyle(color: Colors.white),),
        ),
        body: _getCurrentContent(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            title: Text(
              '英雄'
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps,),
              title: Text(
                  '物品'
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_emoticon,),
              title: Text(
                  '技能'
              )
          ),
        ],
        currentIndex: _currentTabbarIndex,
        onTap: (int index) {
          setState(() {
            _currentTabbarIndex=index;
          });
        },
      ),
    );
  }
}