import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../Net/Net.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Router/AppRouter.dart';


class HeroInfo extends StatefulWidget {
  HeroData hero;
  HeroInfo({Key key, this.hero}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HeroInfoState();
  }
}

class _HeroInfoState extends State<HeroInfo> {

  int _selected = 0;

  Widget _getSkillItem(int index, double width) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = index;
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(width/2),
                ),
                color: index==_selected?Theme.of(context).primaryColor:null,
              ),
            ),
            CachedNetworkImage(
              fit: BoxFit.fill,
              width: width-4,
              height: width-4,
              imageUrl: 'https:${widget.hero.skills[index].image}',
              placeholder: (BuildContext context, String url) {
                return CircularProgressIndicator();
              },
              errorWidget: (BuildContext context, String url, Object error) {
                if (widget.hero.backImageUrl == null) {
                  return CircularProgressIndicator();
                }
                return Icon(Icons.error_outline);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.hero.backImageUrl == null) {
      getHeroInfo(widget.hero, (backImageUrl, skills) {
        setState(() {
          widget.hero.backImageUrl = backImageUrl;
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
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: width,
            height: width*3/4,
            imageUrl: 'https:${widget.hero.backImageUrl}',
            placeholder: (BuildContext context, String url) {
              return CircularProgressIndicator();
            },
            errorWidget: (BuildContext context, String url, Object error) {
              if (widget.hero.backImageUrl == null) {
                return CircularProgressIndicator();
              }
              return Icon(Icons.error_outline);
            },
          ),
          SizedBox(
            width: width,
            height: 90,
            child: ListView.builder(
              itemExtent: 90,
              itemCount: widget.hero.skills==null?0:widget.hero.skills.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _getSkillItem(index, 70);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.hero.skills==null?'':widget.hero.skills[_selected].name,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Text(
                widget.hero.skills==null?'':widget.hero.skills[_selected].desc,
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
          )
        ],
      )
    );
  }
}