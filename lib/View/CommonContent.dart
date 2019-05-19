import 'package:flutter/material.dart';
import '../Model/HeroData.dart';
import '../View/AppComponent.dart';
import '../Net/Net.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CommonContent extends StatefulWidget {
  CommonContent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CommonContentState();
  }
}

class _CommonContentState extends State<CommonContent> {

  List<CommonSkill> _skills = [];
  int _selected = 0;

  @override
  void initState() {
    if (AppComponent.commonSkills != null) {
      _skills = AppComponent.commonSkills;
      return;
    }
    final future = getCommonSkill();
    future.then((value) {
      setState(() {
        _skills = value;
        AppComponent.commonSkills = value;
      });
    });
  }

  Widget _getItem(double width, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = index;
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            color: _selected==index?Theme.of(context).primaryColor:Colors.white,
            padding: EdgeInsets.all(2),
            child: CachedNetworkImage(
              width: width-4,
              height: width-4,
              fit: BoxFit.fill,
              imageUrl: 'https:${_skills[index].href}',
              placeholder: (BuildContext context, String url) {
                return CircularProgressIndicator();
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return Icon(Icons.error_outline);
              },
            ),
          ),
          Text(_skills[index].name),
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

  Widget buildContent() {
    final width = (MediaQuery.of(context).size.width-40)/4;
    final aspect = width/(width+20);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width*0.6,
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width*0.6,
            fit: BoxFit.fill,
            imageUrl: 'https:${_skills[_selected].showImageHref}',
            placeholder: (BuildContext context, String url) {
              return CircularProgressIndicator();
            },
            errorWidget: (BuildContext context, String url, Object error) {
              return Icon(Icons.error_outline);
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(5),
            itemCount: _skills.length,
            itemBuilder: (BuildContext context, int index) {
              return _getItem(width, index);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: aspect
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _skills.length==0?loading():buildContent();
  }
}


