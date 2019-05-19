import 'package:flutter/material.dart';
import '../Router/AppRouter.dart';
import '../Model/ArticleData.dart';
import '../Model/HeroData.dart';


class AppComponent extends StatefulWidget {

  static List<ArticleData> articles;
  static List<HeroData> heros;

  AppComponent({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppComponetState();
  }
}

class _AppComponetState extends State<AppComponent> {
  _AppComponetState() {
    Application.buildRouter();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '王者荣耀',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      onGenerateRoute: Application.router.generator,
    );
  }
}