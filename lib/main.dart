import 'package:filld_rider/pages/Onetimepassword.dart';
import 'package:filld_rider/pages/homepage.dart';
import 'package:filld_rider/pages/sigin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
void main() {
  runApp(const MyApp());
}
DatabaseReference clientdb = FirebaseDatabase.instance.ref().child("Riders");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
    debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
        ? '/onboarding'
            : '/Homepage',
        routes: {
        "/splash":(context) => SplashScreen(),
        "/onboarding":(context)=> OnBoardingPage(),
        "/verify": (context) => OtpVerificationScreen(verificationId: '',),
        // "/SignUP": (context) => SignupPage(),
        "/authpage": (context) =>  AuthPage(),
        "/Homepage": (context) => homepage(),


    );
  }
}


