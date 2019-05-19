import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../View/AppHome.dart';
import '../View/HeroInfo.dart';
import '../View/AppComponent.dart';
import '../View/HeroVideo.dart';

class Application {
  static Router router;
  static buildRouter() {
    router = Router();
    router.define('/', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
          return AppHome();
        }
    ));
    router.define('/hero_info', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
          int index = int.parse(parameters['heroIndex'].first);
          return HeroInfo(
            hero: AppComponent.heros[index],
          );
        }
    ));
    router.define('/hero_info/hero_video', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
          int index = int.parse(parameters['heroIndex'].first);
          return HeroVideo(
            hero: AppComponent.heros[index],
          );
        }
    ));
  }
}