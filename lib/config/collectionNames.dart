import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final userRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection('posts');
final Reference storageRef = FirebaseStorage.instance.ref();
final calenderRef = FirebaseFirestore.instance.collection('calenderMeetings');
final appointmentsRef = FirebaseFirestore.instance.collection('appointments');
