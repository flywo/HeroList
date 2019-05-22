import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../Router/AppRouter.dart';
import '../Model/HeroData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../View/AppComponent.dart';
import '../Net/Net.dart';
import '../CustomWidget/LoadingDialog.dart';

class HeroVideo extends StatefulWidget {
  final HeroData hero;
  HeroVideo({Key key, this.hero}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HeroVideoState();
  }
}

class _HeroVideoState extends State<HeroVideo> {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  List<dynamic> _videos = [];

  Widget _getVideoItem(int index) {

    if (index.isOdd) {
      return Divider(
        height: 1,
      );
    } else {
      index = (index/2).round();
    }

    final videoMap = _videos[index] as Map<String, dynamic>;
    String href = videoMap['sIMG'];//预览图
    String title = videoMap['sTitle'];//标题
    String detail = videoMap['sDesc'];//描述
    String videoID = videoMap['iVideoId'];//id
    String totalTime = videoMap['iTime'];//总时长
    String totalPlay = videoMap['iTotalPlay'];//总播放
    String createTime = videoMap['sIdxTime'];//创建时间


    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return LoadingDialog(
                text: '获取视频中...',
              );
            });
        queryVideoInfo(videoID).then((value) {
          Navigator.pop(context);
          setState(() {
            play(value, true);
          });
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: CachedNetworkImage(
                width: 120,
                height: 90,
                fit: BoxFit.fill,
                imageUrl: 'https:$href',
                placeholder: (BuildContext context, String url) {
                  return const Icon(Icons.file_download, color: Colors.orange,);
                },
                errorWidget: (BuildContext context, String url, Object error) {
                  if (widget.hero.skills == null) {
                    return const Icon(Icons.file_download, color: Colors.orange,);
                  }
                  return const Icon(Icons.error_outline);
                },
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        detail,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey
                        ),
                      ),
                      Text(
                          '播放:$totalPlay次    时长:$totalTime    创建:$createTime',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 8,
                              color: Theme.of(context).primaryColor
                          )
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (AppComponent.videos == null) {
      getNewVideos().then((value1) {
        AppComponent.videos = value1;
        getUpVideos().then((value2) {
          AppComponent.videos2 = value2;
          setState(() {
            final videos3 = AppComponent.videos2[HeroData.mapVlue[widget.hero.number]]['jData'];
            _videos = AppComponent.videos[widget.hero.name];
            _videos.addAll(videos3);
          });
        });
      });
    } else {
      final videos2 = AppComponent.videos2[HeroData.mapVlue[widget.hero.number]]['jData'];
      _videos = AppComponent.videos[widget.hero.name];
      _videos.addAll(videos2);
    }
  }

  void play(String url, bool autoPlay) {
    if (_chewieController!=null) {
      _chewieController.dispose();
    }
    if (_videoPlayerController!=null) {
      _videoPlayerController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: () {
          Application.router.pop(context);
        }),
        title: const Text('英雄视频', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _videoPlayerController==null?<Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: _videos.length*2,
                itemBuilder: (BuildContext context, int index) {
                  return _getVideoItem(index);
                },
              ),
            ),
          )
        ]:<Widget>[
          Chewie(
            controller: _chewieController,
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: _videos.length*2,
                itemBuilder: (BuildContext context, int index) {
                  return _getVideoItem(index);
                },
              ),
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