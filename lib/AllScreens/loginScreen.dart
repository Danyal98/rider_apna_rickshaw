import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_apna_rickshaw/AllScreens/mainscreen.dart';
import 'package:rider_apna_rickshaw/AllScreens/registrationScreen.dart';
import 'package:rider_apna_rickshaw/AllWidgets/progressDialog.dart';
import 'package:rider_apna_rickshaw/main.dart';

class LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,),
              Image(
                image: AssetImage("images/rickshaw-green.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 15.0,),
              Text(
                "Login as Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),



              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 10.0,),
                    ElevatedButton(
                      onPressed: (){
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email Address is not valid", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Password can not be empty!", context);
                        }
                        else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        primary: Colors.tealAccent.shade200,
                      ),
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold", color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
              }, child: Text(
                "Do not have an account? Register Here.",
              ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  loginAndAuthenticateUser(BuildContext context) async{

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return ProgressDialog(message: "Logging In",);
      });

    final User? fireBaseUser = (await _firebaseAuth
      .signInWithEmailAndPassword(email: emailTextEditingController.text,
      password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(fireBaseUser != null)
    {

      usersRef.child(fireBaseUser.uid).once().then((event){
        final DataSnapshot = event.snapshot;
        if (DataSnapshot.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Login Successful", context);
        }
        else{
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("User not found. Please register", context);
        }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Could not sign in", context);
    }
  }
}


