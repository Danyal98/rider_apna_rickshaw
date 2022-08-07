import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_apna_rickshaw/AllScreens/loginScreen.dart';
import 'package:rider_apna_rickshaw/AllScreens/mainscreen.dart';
import 'package:rider_apna_rickshaw/AllScreens/registrationScreen.dart';
import 'package:rider_apna_rickshaw/DataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Apna Rickshaw',
        theme: ThemeData(
          primarySwatch: Colors.teal,

        ),
        initialRoute: LoginScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),

        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}