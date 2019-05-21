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
    super.initState();
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
            width: width,
            height: width,
            color: _selected==index?Theme.of(context).primaryColor:Colors.white,
            padding: const EdgeInsets.all(2),
            child: CachedNetworkImage(
              width: width-4,
              height: width-4,
              fit: BoxFit.fill,
              imageUrl: 'https:${_skills[index].href}',
              placeholder: (BuildContext context, String url) {
                return const Icon(Icons.file_download, color: Colors.orange,);
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return const Icon(Icons.error_outline);
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
          const CircularProgressIndicator(),
          const Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const Text('加载中...'),
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
              return const Icon(Icons.file_download, color: Colors.orange,);
            },
            errorWidget: (BuildContext context, String url, Object error) {
              return const Icon(Icons.error_outline);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                _skills.length==0?'':_skills[_selected].name,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20
                ),
              ),
              Text(
                _skills.length==0?'':_skills[_selected].rank,
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
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width-20,
          child: Text(
            _skills.length==0?'':_skills[_selected].description,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(5),
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


