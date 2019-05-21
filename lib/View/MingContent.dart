import 'package:flutter/material.dart';
import '../Model/MingData.dart';
import '../View/AppComponent.dart';
import '../Net/Net.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../CustomWidget/LoadingDialog.dart';


class MingContent extends StatefulWidget {
  MingContent({Key key}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MingContentState();
  }
}

class _MingContentState extends State<MingContent> {

  List<MingData> _mingList = [];

  @override
  void initState() {
    super.initState();
    if (AppComponent.mings != null) {
      _mingList = AppComponent.mings;
      return;
    }
    final future = getMings();
    future.then((value) {
      setState(() {
        _mingList = value;
        AppComponent.mings = value;
      });
    });
  }

  Widget _getItem(double width, int index, MingData ming) {
    return GestureDetector(
      onTap: () {
        showDetail(_mingList[index]);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: Center(
              child: CachedNetworkImage(
                width: width*0.85,
                height: width,
                fit: BoxFit.fill,
                imageUrl: 'https:${ming.href}',
                placeholder: (BuildContext context, String url) {
                  return const Icon(Icons.file_download, color: Colors.orange,);
                },
                errorWidget: (BuildContext context, String url, Object error) {
                  return const Icon(Icons.error_outline);
                },
              ),
            ),
          ),
          Text(ming.name),
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const Text('加载中...'),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    final width = (MediaQuery.of(context).size.width-60)/5;
    final aspect = width/(width+20);
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: _mingList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getItem(width, index, _mingList[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: aspect
      ),
    );
  }

  void showDetail(MingData ming) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MingDialog(
            ming: ming,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _mingList.length==0?loading():listView();
  }
}