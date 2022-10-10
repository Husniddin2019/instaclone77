import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/servise/prefs_servise.dart';
import '../pages/sign_in.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;

  static Future<Map<String, User?>?> signInUser(BuildContext context, String email, String password) async {
    Map <String,User?> map = {};

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map.addAll({"Succes": user});
      return map;
    } catch (error) {
      print('Sign In ***** => $error');
      map.addAll({"ERROR":null});
      return null;
    }
  }

  static Future<Map<String, User?>> signUpUser(BuildContext context, String name, String email, String password) async {
   Map <String,User?> map = {};
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user! ;
      map.addAll({"Succes": user});


    } catch (error) {
      print(error.toString());
      map.addAll({"ERROR": null});
    }
   return map;
  }


  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SigInPage.id);
    });
  }
}