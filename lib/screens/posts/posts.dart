import 'package:animator/animator.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:forever_alumni/config/collectionNames.dart';
import 'package:forever_alumni/constants.dart';
import 'package:forever_alumni/tools/customImages.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//actually a model like user model class but written in the same file with post widget so that we can add methods to it to pass them to our state class
class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String userName;
  final String postTitle;
  final String description;
  final String postMediaUrl;
  final String subHeading;
  final dynamic likes;
  final String videoLink;

  Post({
    this.postId,
    this.ownerId,
    this.userName,
    this.postTitle,
    this.description,
    this.postMediaUrl,
    this.likes,
    this.subHeading,
    this.videoLink,
  });
  factory Post.fromDocument(doc) {
    return Post(
      postId: doc.data()["postId"],
      ownerId: doc.data()["ownerId"],
      userName: doc.data()["userName"],
      description: doc.data()["description"],
      postTitle: doc.data()["postTitle"],
      postMediaUrl: doc.data()["postMediaUrl"],
      likes: doc.data()['likes'],
      subHeading: doc.data()['subHeading'],
      videoLink: doc.data()['videoLink'],
    );
  }
  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      userName: this.userName,
      description: this.description,
      postMediaUrl: this.postMediaUrl,
      postTitle: this.postTitle,
      likes: this.likes,
      likeCount: getLikeCount(likes),
      subHeading: this.subHeading,
      videoLink: this.videoLink);
}

class _PostState extends State<Post> {
  bool _isLiked = false;
  bool showHeart = false;
  // final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String userName;
  final String postTitle;
  final String description;
  final String subHeading;
  final String postMediaUrl;
  final String videoLink;
  //AnimationController _controller;
  int likeCount;
  Map likes;
  _PostState({
    this.postId,
    this.ownerId,
    this.userName,
    this.postTitle,
    this.description,
    this.postMediaUrl,
    this.likes,
    this.likeCount,
    this.subHeading,
    this.videoLink,
  });

  YoutubePlayerController _ytController;

  List allAdmins = [];
  @override
  initState() {
    _ytController = YoutubePlayerController(
      initialVideoId: videoLink != null ? videoLink : "",
      flags: YoutubePlayerFlags(
        autoPlay: false,
        hideThumbnail: false,
        controlsVisibleAtStart: true,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  dispose() {
    _ytController.dispose();
    super.dispose();
  }

  showProfile(BuildContext context, {String profileId}) {}

  buildPostHeader() {
    return Container();
  }

  handleOptionPost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Text(
                      'Edit',
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deletePost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(child: Text('Cancel')),
                ),
              )
            ],
          );
        });
  }

//Note:to delete Post,ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    postsRef.doc(postId).get().then((doc) {
      if (doc.exists) {}
      doc.reference.delete();
      postsRef.doc(postId).get().then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    });
    //delete post from storage
    storageRef.child("post_$postId.jpg").delete();
    //then delete all activityFeed notifications

    //then delete all comments

    BotToast.showText(text: "Post Deleted Please Refresh");
  }

  buildPostImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        cachedNetworkImage(postMediaUrl),
        showHeart
            ? Animator<double>(
                duration: Duration(milliseconds: 500),
                cycles: 0,
                curve: Curves.elasticOut,
                tween: Tween<double>(begin: 0.8, end: 1.6),
                builder: (context, anim, child) {
                  return Transform.scale(
                    scale: anim.value,
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  );
                },
              )
            : Text(""),
      ],
    );
  }

  buildPostVideo() {
    return YoutubePlayer(
      controller: _ytController,
      onReady: () {
        print("ready");
      },
      showVideoProgressIndicator: true,
      // aspectRatio: 1,
    );
  }

  buildPostFooter() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          postTitle,
          style: titleTextStyle(),
        ),
        Text(
          description,
          style: titleTextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GlassContainer(
        opacity: 0.1,
        shadowStrength: 16,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              buildPostHeader(),
              videoLink == null ? buildPostImage() : buildPostVideo(),
              buildPostFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // editPostScreen() {
  //   return Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => EditPosts(
  //             description: description,
  //             mediaUrl: postMediaUrl,
  //             postTitle: postTitle,
  //             postId: postId,
  //             currentUserId: currentUserId,
  //             videoLink: videoLink,
  //             subHeading: subHeading,
  //           )));
  // }
}
