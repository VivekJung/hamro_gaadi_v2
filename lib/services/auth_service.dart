import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hamro_gaadi/services/firestore_service.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future emailPasswordLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        //check on this snackbar.. why it is not working

      } else {
        log('Error while signing in $e');
      }
    }
  }

  //register with email and password
  Future emailPasswordRegister(
      String email, String password, String? name, String? type) async {
    log("Email :$email Psswd : $password");
    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      //create a new doc for the user with thee uid
      await FirestoreService(uid: user!.uid.toString()).updateUserInfo(
        user.uid.toString(),
        name ?? "no name",
        type ?? "user",
        email,
        password,
      );
    } on FirebaseAuthException catch (e) {
      log('Error while signing in $e');
    } catch (e) {
      log('Error while signing in $e');
    }
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log('Signing out error!\n ${e.toString()} ');
    }
  }
}

// Future googleLogin() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) return;

//       final googleAuth = await googleUser.authentication;
//       final authCredential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(authCredential);
//     } on FirebaseAuthException catch (e) {
//       log(e.code);
//     }
//   }