import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsModel {
  final String appointmentId;
  final String appointmentTitle;
  final String description;
  final Timestamp startingTime;
  final Timestamp endingTime;
  final Timestamp appointmentDate;

  AppointmentsModel({
    this.appointmentId,
    this.appointmentTitle,
    this.description,
    this.startingTime,
    this.endingTime,
    this.appointmentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "appointmentId": appointmentId,
      "appointmentTitle": appointmentTitle,
      "startingTime": startingTime,
      "endingTime": endingTime,
      "appointmentDate": appointmentDate,
      "description": description,
    };
  }

  factory AppointmentsModel.fromMap(Map map) {
    return AppointmentsModel(
      appointmentId: map["appointmentId"],
      appointmentTitle: map["appointmentTitle"],
      startingTime: map["startingTime"],
      endingTime: map["endingTime"],
      appointmentDate: map["appointmentDate"],
      description: map["description"],
    );
  }

  factory AppointmentsModel.fromDocument(doc) {
    return AppointmentsModel(
      appointmentId: doc.data()["appointmentId"],
      appointmentTitle: doc.data()["appointmentTitle"],
      startingTime: doc.data()["startingTime"],
      endingTime: doc.data()["endingTime"],
      appointmentDate: doc.data()["appointmentDate"],
      description: doc.data()["description"],
    );
  }
}
