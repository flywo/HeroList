import 'package:flutter/material.dart';
import '../Model/ArticleData.dart';
import 'package:cached_network_image/cached_network_image.dart';


class LoadingDialog extends Dialog {
  String text;
  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)));

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Material(
              elevation: 24.0,
              color: Theme.of(context).dialogBackgroundColor,
              type: MaterialType.card,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: new Text(text),
                  ),
                ],
              ),
              shape: _defaultDialogShape,
            ),
          ),
        ),
      ),
    );
  }
}



class ArticleDialog extends Dialog {
  ArticleData article;
  ArticleDialog({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)));

    var desc1 = article.desc1.replaceAllMapped(RegExp(r'<p>|</p>'), (Match match) => '');
    desc1 = desc1.replaceAllMapped(RegExp('<br>'), (Match match) => '\n');
    final desc2 = article.desc2.replaceAllMapped(RegExp(r'<p>|</p>'), (Match match) => '');

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 80.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Material(
            elevation: 24.0,
            color: Colors.black.withOpacity(0.95),
            type: MaterialType.transparency,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      imageUrl: 'https:${article.href}',
                      placeholder: (BuildContext context, String url) {
                        return CircularProgressIndicator();
                      },
                      errorWidget: (BuildContext context, String url, Object error) {
                        return Icon(Icons.error_outline);
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("  出售价格："+article.sellPrice, style: TextStyle(color: Theme.of(context).primaryColor),),
                        Text("  购买价格："+article.buyPrice, style: TextStyle(color: Theme.of(context).primaryColor),),
                      ],
                    )
                  ],
                ),
                Text("\n"+desc1, style: TextStyle(color: Theme.of(context).primaryColor),),
                Text('\n'+desc2, style: TextStyle(color: Theme.of(context).primaryColor),),
              ],
            ),
            shape: _defaultDialogShape,
          ),
        ),
      ),
    );
  }
}