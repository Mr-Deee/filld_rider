import 'package:filld_rider/pages/Onetimepassword.dart';
import 'package:filld_rider/pages/homepage.dart';
import 'package:filld_rider/pages/Authpage.dart';
import 'package:filld_rider/pages/riderdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'onboarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



void main()async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(Duration(seconds: 2)); // Adjust the duration as needed
  FlutterNativeSplash.remove();
  runApp( MyApp());
}

DatabaseReference clientdb = FirebaseDatabase.instance.ref().child("Riders");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fill'+''+'d'+'Rider',
      theme: ThemeData(),
    debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
        ? '/onboarding'
            : '/Riderdetails',
        routes: {
          // "/splash":(context) => SplashScreen(),
          "/onboarding": (context) => OnBoardingPage(),
          "/verify": (context) => OtpVerificationScreen(verificationId: '',),
          "/Riderdetails": (context) => Riderdetails(),

          // "/SignUP": (context) => SignupPage(),
          "/authpage": (context) => AuthPage(),
          "/Homepage": (context) => homepage(),


        });
  }
}


