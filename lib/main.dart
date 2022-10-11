import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instaclone/pages/homepage.dart';
import 'package:instaclone/pages/sign_in.dart';
import 'package:instaclone/pages/sign_up.dart';
import 'package:instaclone/pages/splashpage.dart';
import 'package:instaclone/servise/prefs_servise.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  var initAndroidSetting = AndroidInitializationSettings('@mipmap/1claunvher');
  var initSetting = InitializationSettings(android: initAndroidSetting );
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  await  Firebase.initializeApp().then((value) => print("firebase ishga tushdi"),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Widget _callstartPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Prefs.saveUserId(snapshot.data!.uid);
          return Splashpage();
        } else {
          Prefs.removeUserId();
          return SigInPage();
        }
      },
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: _callstartPage(),
      routes: {
        Splashpage.id:(context) => Splashpage(),
        SigInPage.id:(context) => SigInPage(),
        SignUp.id:(context) => SignUp(),
        HomePage.id:(context) => HomePage(),
      }
      ,
    );
  }
}
