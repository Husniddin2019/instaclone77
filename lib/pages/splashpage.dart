import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/homepage.dart';
import 'package:instaclone/pages/sign_in.dart';

import '../servise/prefs_servise.dart';
class Splashpage extends StatefulWidget {
  const Splashpage({Key? key}) : super(key: key);
  static final String id = "splash_page";

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
   FirebaseMessaging? firebaseMessaging;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseMessaging=FirebaseMessaging.instance;
    _initNotification();
    _initTimer();
  }

  _initNotification() async {
    firebaseMessaging?.setForegroundNotificationPresentationOptions(
        sound: true, badge: true, alert: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      print (notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });





    FirebaseMessaging.instance.getToken().then((String? token) {
      if(token != null){
        if (kDebugMode) {
          print(token);
        }
        Prefs.saveFCM(token);
      }

    });
  }

  _initTimer(){
    Timer(Duration(seconds: 2),(){
      _callHomePage();
    });
  }
  _callHomePage(){
    Navigator.pushReplacementNamed(context, SigInPage.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(252, 175, 69, 1),
              Color.fromRGBO(250, 153, 1, 1),
            ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Center(
              child: Text(
                "Instagram",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'Billabong'
                ),
              ),
            )),
            Text("All right reserved"),
            SizedBox(height: 20,)
          ],
        ),

      ),
    );
  }
}
