import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_apna_rickshaw/AllScreens/loginScreen.dart';
import 'package:rider_apna_rickshaw/AllScreens/mainscreen.dart';
import 'package:rider_apna_rickshaw/AllWidgets/progressDialog.dart';
import 'package:rider_apna_rickshaw/main.dart';

class RegistrationScreen extends StatelessWidget
{

  static const String idScreen = "registeration";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  // const RegistrationScreen({Key? key}) : super(key: key);

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
                "Register as Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),



              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone No",
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
                        if(nameTextEditingController.text.length < 5)
                        {
                          displayToastMessage("Name must be atleast 4 characters", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email Address is not valid", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Phone Number cannot be empty", context);
                        }
                        else if(passwordTextEditingController.text.length < 8)
                        {
                          displayToastMessage("Password must contain 8 letters", context);
                        }
                        else
                        {
                          registerNewUser(context);
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
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold", color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

              }, child: Text(
                "Already have an account? Login Here.",
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
  registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering, Please wait",);
        });

    final User? fireBaseUser = (await _firebaseAuth.
      createUserWithEmailAndPassword(email: emailTextEditingController.text,
      password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(fireBaseUser != null)
    {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(fireBaseUser.uid).set(userDataMap);
      displayToastMessage("Condratulations! Your Account is created. Please Sign in", context);

      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Could not add User", context);
    }
  }
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}