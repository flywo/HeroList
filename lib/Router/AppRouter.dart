import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../View/AppHome.dart';
import '../View/HeroInfo.dart';
import '../Model/HeroData.dart';

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
          return HeroInfo(
            hero: HeroData(
              href: parameters['href'].first.replaceAll('`', '/'),
              name: parameters['name'].first,
              infoHref: parameters['infoHref'].first.replaceAll('`', '/'),
              number: parameters['number'].first
            ),
          );
        }
    ));
  }
}