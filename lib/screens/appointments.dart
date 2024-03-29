import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forever_alumni/Database/database.dart';
import 'package:forever_alumni/constants.dart';
import 'package:forever_alumni/models/appointmentsModel.dart';
import 'package:forever_alumni/screens/homepage.dart';
import 'package:forever_alumni/screens/newAppointments.dart';
import 'package:forever_alumni/tools/loading.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List<AppointmentsModel> allAppointments = [];

  bool _isLoading = false;
  bool _noAppointment = false;
  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  getAppointments() async {
    setState(() {
      _isLoading = true;
    });
    List<AppointmentsModel> allAppointmentsTemp = [];
    QuerySnapshot allAppointmentsSnapshots = await DatabaseMethods()
        .fetchAppointmentDataFromFirebase(uid: userUid)
        .onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
        _noAppointment = true;
      });
    });
    allAppointmentsSnapshots.docs.forEach((e) {
      allAppointmentsTemp.add(AppointmentsModel.fromDocument(e));
    });
    print(_noAppointment);
    setState(() {
      this.allAppointments = allAppointmentsTemp;

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GlassContainer(
                  opacity: 0.1,
                  width: double.infinity,
                  shadowStrength: 16,
                  child: Center(
                    child: Text(
                      "Announcements",
                      style: titleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome $userName",
                    style: titleTextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
                Center(child: Lottie.asset(appointmentLottie, height: 300)),
              ],
            ),
            _isLoading
                ? LoadingIndicator()
                : ListView(
                    children: [
                      SizedBox(
                        height: 400,
                      ),
                      _noAppointment
                          ? GlassContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(36.0),
                                child: Text(
                                  "No Appointment",
                                  style: titleTextStyle(fontSize: 32),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                DateTime appointDate = allAppointments[index]
                                    .appointmentDate
                                    .toDate();
                                String appointmentDateString =
                                    "${appointDate.day} - ${appointDate.month} - ${appointDate.year}";
                                DateTime start = allAppointments[index]
                                    .startingTime
                                    .toDate();
                                String startString =
                                    "${start.hour}:${start.minute}";
                                DateTime end =
                                    allAppointments[index].endingTime.toDate();
                                String endString = "${end.hour}:${end.minute}";
                                return AppointmentWidget(
                                  appointmentTimings:
                                      "Timings $startString - $endString",
                                  comment: allAppointments[index].description,
                                  date: appointmentDateString,
                                  name: allAppointments[index].appointmentTitle,
                                );
                              },
                              itemCount: allAppointments.length,
                            ),
                    ],
                  ),
            Positioned(
                right: 10,
                bottom: 60,
                child: GestureDetector(
                  onTap: () => Get.to(() => NewAppointments())
                      .then((value) => getAppointments()),
                  child: GlassContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text("Add New Appointment")
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({
    this.appointmentTimings,
    this.comment,
    this.name,
    this.date,
  });
  final String appointmentTimings;
  final String comment;
  final String name;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassContainer(
        opacity: 0.3,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Appointment Timing:",
                            style: averageTextStyle(fontSize: 16),
                          ),
                          Text(
                            date,
                            style: averageTextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer),
                          Text(
                            appointmentTimings,
                            style: averageTextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            maxRadius: 32,
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Text(
                              name,
                              style: averageTextStyle(fontSize: 23),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        comment,
                        style: averageTextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
