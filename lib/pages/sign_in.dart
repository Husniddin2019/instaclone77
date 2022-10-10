import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/sign_up.dart';

import '../model/user_model.dart';
import '../servise/auth_servise.dart';
import '../servise/prefs_servise.dart';
import '../servise/utils_servise.dart';
import 'homepage.dart';
class SigInPage extends StatefulWidget {
  static final String id = "sigin_page";
  const SigInPage({Key? key}) : super(key: key);

  @override
  State<SigInPage> createState() => _SigInPageState();
}

class _SigInPageState extends State<SigInPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false;
  _callSignUpPage(){
    Navigator.pushReplacementNamed(context, SignUp.id);
  }


  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((value) => {
      _getFirebaseUser(value),
    });
  }

  _getFirebaseUser(Map<String, User?>? map) async {
    setState(() {
      isLoading = false;
    });
    User?  firebaseUser;
    print("zero=>>>>>>   $map");
    if (map!.containsKey("Succes")) {
      firebaseUser = map["Succes"];
       await Prefs.saveUserId(firebaseUser!.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
        Utils.fireToast("Check email or password");
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Instagram",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: 'Billabong'
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 17.0,color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 17.0,color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap:(){_doSignIn();},
                    child:Container (
                      alignment: Alignment.bottomCenter,
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.all( 10,),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white54.withOpacity(0.2),width: 2
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,fontSize: 17
                        ),
                      ),
                    ),
                  ),


                ],
              ),
              isLoading ?
                  Center(
                    child: CircularProgressIndicator(),
                  ):SizedBox.shrink(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account",style: TextStyle(color: Colors.white,fontSize: 16),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: _callSignUpPage,
                        child: Text("Sign Up", style: TextStyle( color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
