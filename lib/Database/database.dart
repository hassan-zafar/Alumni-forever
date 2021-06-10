import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forever_alumni/Database/local_database.dart';
import 'package:forever_alumni/config/collectionNames.dart';
import 'package:forever_alumni/models/appointmentsModel.dart';
import 'package:forever_alumni/models/userModel.dart';
import 'package:forever_alumni/screens/appointments.dart';
import 'package:forever_alumni/screens/homepage.dart';
import 'package:forever_alumni/tools/custom_toast.dart';

class DatabaseMethods {
  // Future<Stream<QuerySnapshot>> getproductData() async {
  //   return FirebaseFirestore.instance.collection(productCollection).snapshots();
  // }

  Future addUserInfoToFirebase(
      {@required UserModel userModel,
      @required String userId,
      @required email}) async {
    final Map<String, dynamic> userInfoMap = userModel.toMap();
    return userRef.doc(userId).set(userInfoMap).then((value) {
      UserLocalData().setUserUID(userModel.userId);
      UserLocalData().setUserEmail(userModel.email);
      UserLocalData().setUserName(userModel.userName);
      UserLocalData().setIsAdmin(userModel.isAdmin);
    }).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }

  Future fetchUserInfoFromFirebase({@required String uid}) async {
    final DocumentSnapshot _user = await userRef.doc(uid).get();
    UserModel currentUser = UserModel.fromDocument(_user);
    UserLocalData().setUserUID(currentUser.userId);
    UserLocalData().setUserEmail(currentUser.email);
    UserLocalData().setIsAdmin(currentUser.isAdmin);
    isAdmin = currentUser.isAdmin;
    print(currentUser.email);
  }

  Future fetchCalenderDataFromFirebase() async {
    final QuerySnapshot calenderMeetings = await calenderRef.get();

    return calenderMeetings;
  }

  Future fetchPostsDataFromFirebase() async {
    final QuerySnapshot allPostsSnapshots = await postsRef.get();

    return allPostsSnapshots;
  }

  Future fetchAppointmentDataFromFirebase({@required String uid}) async {
    final QuerySnapshot allAppointmentsSnapshots =
        await appointmentsRef.doc(uid).collection("userAppointments").get();

    return allAppointmentsSnapshots;
  }
}
