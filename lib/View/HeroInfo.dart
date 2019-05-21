import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import '../View/AppComponent.dart';
import '../CustomWidget/LoadingDialog.dart';
import '../Model/ArticleData.dart';


class HeroInfo extends StatefulWidget {
  final HeroData hero;
  HeroInfo({Key key, this.hero}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HeroInfoState();
  }
}

class _HeroInfoState extends State<HeroInfo> {

  int _skillSelected = 0;
  int _skinSelected = 0;
  int _recommendSelected = 0;

  Widget _getSkillItem(int index, double width) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _skillSelected = index;
        });
      },
      child: Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(width/2),
          ),
          color: index==_skillSelected?Theme.of(context).primaryColor:null,
        ),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: 'https:${widget.hero.skills[index].image}',
          placeholder: (BuildContext context, String url) {
            return const Icon(Icons.file_download, color: Colors.orange,);
          },
          errorWidget: (BuildContext context, String url, Object error) {
            if (widget.hero.skills == null) {
              return const Icon(Icons.file_download, color: Colors.orange,);
            }
            return const Icon(Icons.error_outline);
          },
        ),
      ),
    );
  }

  Widget _getSkinItem(int index, double width) {
    return Tooltip(
      preferBelow: false,
      message: widget.hero.skins[index].name,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _skinSelected = index;
          });
        },
        child: Container(
          width: width,
          height: width,
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.all(5),
          color: index==_skinSelected?Colors.white:null,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: 'https:${widget.hero.skins[index].smallHref}',
            placeholder: (BuildContext context, String url) {
              return const Icon(Icons.file_download, color: Colors.orange,);
            },
            errorWidget: (BuildContext context, String url, Object error) {
              if (widget.hero.skins == null) {
                return const Icon(Icons.file_download, color: Colors.orange,);
              }
              return const Icon(Icons.error_outline);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSkinStack(double width) {
    if (widget.hero.skins == null) {
      return Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          SizedBox(
            width: width,
            height: 70,
            child: ListView.builder(
              itemExtent: 70,
              itemCount: widget.hero.skins==null?0:widget.hero.skins.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _getSkinItem(index, 70);
              },
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          CachedNetworkImage(
            width: width,
            height: width*3/4,
            fit: BoxFit.cover,
            imageUrl: 'https:${widget.hero.skins[_skinSelected].href}',
            placeholder: (BuildContext context, String url) {
              return const Icon(Icons.file_download, color: Colors.orange,);
            },
            errorWidget: (BuildContext context, String url, Object error) {
              if (widget.hero.skins == null) {
                return const Icon(Icons.file_download, color: Colors.orange,);
              }
              return const Icon(Icons.error_outline);
            },
          ),
          SizedBox(
            width: width,
            height: 70,
            child: ListView.builder(
              itemExtent: 70,
              itemCount: widget.hero.skins==null?0:widget.hero.skins.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _getSkinItem(index, 70);
              },
            ),
          ),
        ],
      );
    }
  }

  List<Widget> _getRecommend() {
    if (widget.hero.recommend1==null) {
      return [];
    }
    final button1 = FlatButton(
      color: _recommendSelected == 0 ? Theme
          .of(context)
          .primaryColor : Colors.grey,
      textColor: Colors.white,
      onPressed: () {
        if (_recommendSelected == 0) {
          return;
        }
        setState(() {
          _recommendSelected = 0;
        });
      },
      child: const Text('推荐出装一'),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), bottomLeft: const Radius.circular(10)),
      ),
    );
    final button2 = FlatButton(
      color: _recommendSelected == 1 ? Theme
          .of(context)
          .primaryColor : Colors.grey,
      textColor: Colors.white,
      onPressed: () {
        if (_recommendSelected == 1) {
          return;
        }
        setState(() {
          _recommendSelected = 1;
        });
      },
      child: const Text('推荐出装二'),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
            bottomRight: const Radius.circular(10), topRight: const Radius.circular(10)),
      ),
    );
    final value = (_recommendSelected==0?widget.hero.recommend1:widget.hero.recommend2).split('|');
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            button1,
            button2,
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildArticleImage(value[0]),
          _buildArticleImage(value[1]),
          _buildArticleImage(value[2]),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildArticleImage(value[3]),
          _buildArticleImage(value[4]),
          _buildArticleImage(value[5]),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Text(
          _recommendSelected==0?widget.hero.recommend1desc:widget.hero.recommend2desc,
          style: TextStyle(
              color: Colors.white
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
  }

  void showDetail(ArticleData aritcle) {
    print(aritcle.desc1);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ArticleDialog(article: aritcle);
        });
  }

  Widget _buildArticleImage(String index) {
    if (AppComponent.articles==null) {
      return null;
    }
    final article = AppComponent.articles[AppComponent.articles.indexWhere((value) => value.ID==index)];
    return GestureDetector(
      onTap: () {
        showDetail(article);
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: CachedNetworkImage(
          height: 100,
          width: 100,
          fit: BoxFit.fill,
          imageUrl: 'https:${article.href}',
          placeholder: (BuildContext context, String url) {
            return const Icon(Icons.file_download, color: Colors.orange,);
          },
          errorWidget: (BuildContext context, String url, Object error) {
            if (widget.hero.skills == null) {
              return const Icon(Icons.file_download, color: Colors.orange,);
            }
            return const Icon(Icons.error_outline);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.hero.skills == null) {
      getHeroInfo(widget.hero, (skills, skins, recommends) {
        setState(() {
          widget.hero.skins = skins;
          widget.hero.skills = skills;
          widget.hero.recommend1 = recommends[0];
          widget.hero.recommend1desc = recommends[1];
          widget.hero.recommend2 = recommends[2];
          widget.hero.recommend2desc = recommends[3];
          print(recommends[0]);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: () {
          Application.router.pop(context);
        }),
        title: Text(widget.hero.name, style: const TextStyle(color: Colors.white),),
      ),
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: width,
              height: width*3/4,
              child: _buildSkinStack(width),
            ),
            SizedBox(
              width: width,
              height: 90,
              child: ListView.builder(
                itemExtent: 90,
                itemCount: widget.hero.skills==null?0:widget.hero.skills.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return _getSkillItem(index, 90);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.hero.skills==null?'':widget.hero.skills[_skillSelected].name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20
                    ),
                  ),
                  Text(
                    widget.hero.skills==null?'':('  ${widget.hero.skills[_skillSelected].cooling}  ${widget.hero.skills[_skillSelected].expend}'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Text(
                widget.hero.skills==null?'':widget.hero.skills[_skillSelected].desc,
                style: const TextStyle(
                    color: Colors.white
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(5),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _getRecommend(),
            ),
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context,
                    Uri.encodeFull('/hero_info/hero_video?heroIndex=${AppComponent.heros.indexOf(widget.hero)}'),
                    transition: TransitionType.native);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('想学点技术？点击这里查看视频教学。',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid
                  ),),
              ),
            )
          ],
        ),
      )
    );
  }
}