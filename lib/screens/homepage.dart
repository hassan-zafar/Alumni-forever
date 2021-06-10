import 'package:flutter/material.dart';
import 'package:forever_alumni/screens/appointments.dart';
import 'package:forever_alumni/screens/calender.dart';
import 'package:forever_alumni/screens/extras.dart';
import 'package:forever_alumni/screens/posts/timeline.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../constants.dart';

bool isAdmin = false;
String userUid;
String email;
String userName;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  int pageIndex = 0;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    print(userUid);
    print(userName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Calender(),
                  VideosPage(),
                  Appointments(),
                  Extras(),
                ],
              ),
            ],
          ),
          bottomNavigationBar: GlassContainer(
            opacity: 0.2,
            blur: 8,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: BottomNavigationBar(
              backgroundColor: Color(0x00ffffff),
              currentIndex: pageIndex,
              onTap: onTap,
              elevation: 0,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    label: "Calender"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.video_collection_rounded),
                    label: "Videos"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse_rounded), label: "Appointments"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Extras")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
