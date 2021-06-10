import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forever_alumni/config/collectionNames.dart';
import 'package:forever_alumni/constants.dart';
import 'package:forever_alumni/screens/posts/posts.dart';
import 'package:forever_alumni/screens/posts/uploadPosts.dart';
import 'package:forever_alumni/tools/loading.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage>
    with AutomaticKeepAliveClientMixin<VideosPage> {
  List<Post> posts;

  bool _disposed = false;
  RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await postsRef
        // .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    print(posts);
    if (!_disposed) {
      setState(() {
        this.posts = posts;
      });
    }
  }

  buildTimeline() {
    if (posts == null) {
      return Lottie.asset(videoLottie);
    } else if (posts.isEmpty) {
      return Center(
          child: Column(
        children: [
          Lottie.asset(videoLottie),
          Text('No posts'),
        ],
      ));
    } else {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: posts,
      );
    }
  }

  YoutubePlayerController _ytController;

  @override
  Scaffold build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SmartRefresher(
        child: Stack(
          children: [
            buildTimeline(),
            Positioned(
                bottom: 60,
                right: 10,
                child: GlassContainer(
                  child: GestureDetector(
                    onTap: () => Get.to(() => UploadPosts())
                        .then((value) => getTimeline()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [Icon(Icons.add), Text("Upload Posts")],
                      ),
                    ),
                  ),
                ))
          ],
        ),
        header: WaterDropMaterialHeader(
          distance: 40.0,
        ),
        controller: _refreshController,
        onRefresh: () {
          _refreshController.requestRefresh();
          getTimeline();
          buildTimeline();
          _refreshController.refreshCompleted();
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _disposed = true;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
