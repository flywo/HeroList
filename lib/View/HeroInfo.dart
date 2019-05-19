import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Router/AppRouter.dart';
import 'package:fluro/fluro.dart';
import '../View/AppComponent.dart';


class HeroInfo extends StatefulWidget {
  HeroData hero;
  HeroInfo({Key key, this.hero}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HeroInfoState();
  }
}

class _HeroInfoState extends State<HeroInfo> {

  int _skillSelected = 0;
  int _skinSelected = 0;

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
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(10),
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
            return CircularProgressIndicator();
          },
          errorWidget: (BuildContext context, String url, Object error) {
            if (widget.hero.skills == null) {
              return CircularProgressIndicator();
            }
            return Icon(Icons.error_outline);
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
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.all(5),
          color: index==_skinSelected?Colors.white:null,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: 'https:${widget.hero.skins[index].smallHref}',
            placeholder: (BuildContext context, String url) {
              return CircularProgressIndicator();
            },
            errorWidget: (BuildContext context, String url, Object error) {
              if (widget.hero.skins == null) {
                return CircularProgressIndicator();
              }
              return Icon(Icons.error_outline);
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

  @override
  void initState() {
    if (widget.hero.skills == null) {
      getHeroInfo(widget.hero, (skills, skins) {
        setState(() {
          widget.hero.skins = skins;
          widget.hero.skills = skills;
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
        title: Text(widget.hero.name, style: TextStyle(color: Colors.white),),
      ),
      body: ListView(
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
            padding: EdgeInsets.only(left: 10),
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
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Text(
                widget.hero.skills==null?'':widget.hero.skills[_skillSelected].desc,
                style: TextStyle(
                  color: Colors.white
                ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              Application.router.navigateTo(context,
                  Uri.encodeFull('/hero_info/hero_video?heroIndex=${AppComponent.heros.indexOf(widget.hero)}'),
                  transition: TransitionType.native);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text('想学点技术？点击这里查看视频教学。',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid
                ),),
            ),
          )
        ],
      )
    );
  }
}