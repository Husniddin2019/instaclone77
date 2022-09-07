import 'package:flutter/material.dart';
import 'package:instaclone/pages/sign_in.dart';
import 'package:instaclone/pages/sign_up.dart';
import 'package:instaclone/pages/splashpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Splashpage(),
      routes: {
        Splashpage.id:(context) => Splashpage(),
        SigInPage.id:(context) => SigInPage(),
        SignUp.id:(context) => SignUp(),
      }
      ,
    );
  }
}
