import 'package:flutter/material.dart';
import '../Model/ArticleData.dart';
import '../Net/Net.dart';
import '../CustomWidget/LoadingDialog.dart';
import '../View/AppComponent.dart';
import '../CustomWidget/CustomWidget.dart';


class ArticleContent extends StatefulWidget {
  ArticleContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ArticleContentState();
  }
}

class _ArticleContentState extends State<ArticleContent> {

  List<ArticleData> _articleList = [];
  int _selected = 0;
  bool _showChoice = false;

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
            child: CustomWidget.buildNetImage(
              width: width,
              height: width,
              fit: BoxFit.fill,
              urlStr: 'https:${article.href}',
            )
          ),
          Text(article.name, style: const TextStyle(fontSize: 12),),
        ],
      ),
    );
  }


  void _tidyArticleList() {
    if (_selected==0) {
      setState(() {
        _articleList = AppComponent.articles;
      });
      return;
    }

    List<ArticleData> list = [];
    for (ArticleData item in AppComponent.articles) {
      if (item.type==_selected) {
        list.add(item);
      }
    }
    setState(() {
      _articleList = list;
    });
  }

  //type 0->color 1->level
  Widget _choiceItem(int value, Text text) {
    return Column(
      children: <Widget>[
        Radio<int>(
          groupValue: _selected,
          value: value,
          onChanged: (value) {
            _selected = value;
            _tidyArticleList();
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
          child: const Text('点击筛选装备', style: TextStyle(color: Colors.orange),),
          onPressed: () {
            setState(() {
              _showChoice = true;
            });
          },
        ),
      );
    }
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width-40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width-40,
                  height: 70,
                  child: Scrollbar(
                    child: ListView(
                      itemExtent: 60,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _choiceItem(0, const Text('全部')),
                        _choiceItem(1, const Text('攻击')),
                        _choiceItem(2, const Text('法术')),
                        _choiceItem(3, const Text('防御')),
                        _choiceItem(4, const Text('移动')),
                        _choiceItem(5, const Text('打野')),
                        _choiceItem(7, const Text('辅助')),
                      ],
                    ),
                  ),
                )
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
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-60)/5;
    final aspect = width/(width+20);

    return Column(
      children: <Widget>[
        _buildChoiceView(),
        Expanded(
          child: Scrollbar(
            child: GridView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: _articleList.length,
              itemBuilder: (BuildContext context, int index) {
                return _getItem(width, index, _articleList[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: aspect
              ),
            ),
          ),
        ),
      ],
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
    return _articleList.length==0?CustomWidget.buildLoadingView():listView();
  }
}