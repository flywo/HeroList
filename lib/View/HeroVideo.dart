import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../Router/AppRouter.dart';
import '../Model/HeroData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Net/Net.dart';


class HeroVideo extends StatefulWidget {
  HeroData hero;
  HeroVideo({Key key, this.hero}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HeroVideoState();
  }
}

class _HeroVideoState extends State<HeroVideo> {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  Widget _getVideoItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          play(widget.hero.videos[index].href, true);
        });
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            child: CachedNetworkImage(
              width: 120,
              height: 90,
              fit: BoxFit.fill,
              imageUrl: 'https:${widget.hero.videos[index].imgHref}',
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
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  widget.hero.videos[index].name,
                  maxLines: 4,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    if (widget.hero.videos==null) {
      getVideos(widget.hero.name).then((value) {
        setState(() {
          widget.hero.videos = value;
        });
      });
    }
    play('', false);
  }

  void play(String url, bool autoPlay) {
    if (_chewieController!=null) {
      _chewieController.dispose();
    }
    _videoPlayerController = VideoPlayerController.network(
        url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 3 / 2,
        allowFullScreen: false,
        showControls: true,
        autoPlay: autoPlay
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: () {
          Application.router.pop(context);
        }),
        title: Text('英雄视频', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Chewie(
            controller: _chewieController,
          ),
          Expanded(
            child: ListView.builder(
              itemExtent: 100,
              padding: EdgeInsets.all(5),
              itemCount: widget.hero.videos==null?0:widget.hero.videos.length,
              itemBuilder: (BuildContext context, int index) {
                return _getVideoItem(index);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}