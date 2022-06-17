// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController{
  FirebaseAuth auth=FirebaseAuth.instance;
  final prefs = GetStorage();

  //Sign in user
  Future<String> signIN({String email, String password}) async {
    if(email=="tourtunisie.amvppc@gmail.com"){
      try {
        var res = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        prefs.write('uid', res.user.uid);
        prefs.write('username', res.user.displayName);

        return "Welcome.";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        }
      }
    }
    else {
      return 'Not Authorized!';

    }
  }
}