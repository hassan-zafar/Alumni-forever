import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:forever_alumni/Database/local_database.dart';
import 'package:forever_alumni/constants.dart';
import 'package:forever_alumni/credentials/loginRelated/loginPage.dart';
import 'package:forever_alumni/services/authentication_service.dart';
import 'package:get/get.dart';

class Extras extends StatefulWidget {
  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white12,
                  shape: NeumorphicShape.convex,
                  depth: 8,
                  intensity: 8,
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text("You can donate to the university's Paypal account"),
                    Text("Paypal account : foreverAlumni@gmail.com"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(90.0),
              child: GestureDetector(
                onTap: () {
                  AuthenticationService().signOut();
                  UserLocalData().logOut();
                  Get.off(() => LoginPage());
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: Colors.red,
                    shape: NeumorphicShape.convex,
                    shadowDarkColor: Colors.red.shade900,
                    depth: 8,
                    intensity: 8,
                  ),
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [Icon(Icons.logout), Text("LogOut")],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
