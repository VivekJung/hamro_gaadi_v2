import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future emailPasswordLogin(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              content: Text('No user found for that email')),
        );
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        //check on this snackbar.. why it is not working

        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Wrong password provided for that user')),
        );
      }
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