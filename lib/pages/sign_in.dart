import 'package:flutter/material.dart';
import 'package:instaclone/pages/sign_up.dart';
class SigInPage extends StatefulWidget {
  static final String id = "sigin_page";
  const SigInPage({Key? key}) : super(key: key);

  @override
  State<SigInPage> createState() => _SigInPageState();
}

class _SigInPageState extends State<SigInPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  _callSignUpPage(){
    Navigator.pushReplacementNamed(context, SignUp.id);
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
                  Color.fromRGBO(193, 53, 132, 1),
                  Color.fromRGBO(131, 58, 180, 1),
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
                  Container(
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
