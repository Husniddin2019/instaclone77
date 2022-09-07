import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instaclone/pages/sign_in.dart';
class Splashpage extends StatefulWidget {
  const Splashpage({Key? key}) : super(key: key);
  static final String id = "splash_page";

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  _initTimer(){
    Timer(Duration(seconds: 2),(){
      _callSignInPage();
    });
  }
  _callSignInPage(){
    Navigator.pushReplacementNamed(context, SigInPage.id);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
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
              Color.fromRGBO(193, 53, 132, 1),
              Color.fromRGBO(131, 58, 180, 1),
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
