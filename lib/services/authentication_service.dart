import 'package:firebase_auth/firebase_auth.dart';
import 'package:forever_alumni/Database/database.dart';
import 'package:forever_alumni/models/userModel.dart';
import 'package:forever_alumni/tools/custom_toast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<User> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  Future<String> logIn({
    String email,
    final String password,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return result.user.uid;
    } on FirebaseAuthException catch (e) {
      errorToast(message: e.message);
      return null;
    }
  }
  Future<User> signUp({
    final String password,
    final String userName,
    final timestamp,
    final String email,
    final bool isAdmin,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((Object obj) {
        errorToast(message: obj.toString());
      });
      final User user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      if (user != null) {
        final UserModel currentUser = UserModel(
          userId: user.uid,
          userName: userName,
          email: email.trim(),
          password: password,
          timestamp: timestamp,
          isAdmin: false,
        );
        await DatabaseMethods().addUserInfoToFirebase(
            userModel: currentUser, userId: user.uid, email: email);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      errorToast(message: e.message);
      return null;
    }
  }
}
