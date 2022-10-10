import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/pages/homepage.dart';
import 'package:instaclone/pages/sign_in.dart';
import 'package:instaclone/servise/date_servise.dart';

import '../servise/auth_servise.dart';
import '../servise/prefs_servise.dart';
import '../servise/utils_servise.dart';
class SignUp extends StatefulWidget {
  static final String id = "signup";
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var fullController = TextEditingController();
  var confirmController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false;

  _callSignUpPage(){
    Navigator.pushReplacementNamed(context, SigInPage.id);
  }
  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isalidemail(String value){
    String  pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
}

  _doSignUp(){
    String name = fullController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = confirmController.text.toString().trim();

    if(name.isEmpty || email.isEmpty || password.isEmpty) return;
    if(cpassword!=password ){
      Utils.fireToast("Password and confirm password does not match");
      return;
    }
    // if (!validateStructure(password)) {
    //   Utils.fireToast("password does not match");
    //   return;
    // }
    // if (!isalidemail(email)) {
    //   Utils.fireToast("email does not match");
    //   return;
    // }



    setState(() {
      isLoading = true;
    });
    Users user = new Users(password: password, fullname: name, email: email);

    AuthService.signUpUser(context, name, email, password).then((
        value ) => {
      _getFirebaseUser(user, value),
    });
  }

  _getFirebaseUser(Users user, Map <String,User?> map ) async {
    setState(() {
      isLoading = false;
    });
    User ? firebaseUser;




    if (!map.containsKey("Succes")) {
      print(map);
      // if (map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")) {
      //   Utils.fireToast("Email already in use");
      // }
      if (map.containsKey("ERROR")){
        Utils.fireToast("Try again later");}
      //return;
    }
    firebaseUser = map["Succes"];
   if (firebaseUser == null) return;

   await Prefs.saveUserId(firebaseUser.uid);
    DataServise.storeUser(user).then((value) =>
    {
      Navigator.pushNamed(context, HomePage.id),
    });


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
                          controller: fullController,
                          decoration: InputDecoration(
                            hintText: "Full Name",
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
                          controller: confirmController,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 17.0,color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){_doSignUp();},
                      child: Container(
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
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,fontSize: 17
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
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
                          child: Text("Sign IN", style: TextStyle( color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
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
