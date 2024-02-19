import 'package:filld_rider/Models/Ride_r.dart';
import 'package:filld_rider/Models/appstate.dart';
import 'package:filld_rider/Models/history.dart';
import 'package:filld_rider/Models/hubtelpay.dart';
import 'package:filld_rider/assistants/helper.dart';
import 'package:filld_rider/pages/Onetimepassword.dart';
import 'package:filld_rider/pages/homepage.dart';
import 'package:filld_rider/pages/Authpage.dart';
import 'package:filld_rider/pages/mainscreen.dart';
import 'package:filld_rider/pages/riderdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DataHandler/appData.dart';
import 'Models/Users.dart';
import 'firebase_options.dart';
import 'onboarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';



void main()async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(Duration(seconds: 2)); // Adjust the duration as needed
  FlutterNativeSplash.remove();
  runApp( (MultiProvider( providers: [
    ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
    ),
    ChangeNotifierProvider<Users>(
      create: (context) => Users(),
    ),

    // ChangeNotifierProvider<otherUsermodel>(
    //   create: (context) => otherUsermodel(),
    // ),

    ChangeNotifierProvider<Ride_r>(
      create: (context) =>  Ride_r(),
    ),



    // ChangeNotifierProvider<ReqModel>(
    //   create: (context) => ReqModel(),
    // ),
    // ChangeNotifierProvider<History>(
    //   create: (context) => History(),
    // ),
    ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
    ),



    // ChangeNotifierProvider<AppState>(
    // create: (context) => AppState(),
    // ),
    ChangeNotifierProvider<helper>(
      create: (context) => helper(),
    )
  ], child:MyApp())));
}


final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;



DatabaseReference  clientRequestRef = FirebaseDatabase.instance.ref().child("GasRequests");
DatabaseReference RiderRequestRef= FirebaseDatabase.instance.ref().child("Riders").child(uid!).child("new Rider");
DatabaseReference Ridersdb = FirebaseDatabase.instance.ref().child("Riders");
DatabaseReference Clientsdb = FirebaseDatabase.instance.ref().child("Clients");
DatabaseReference Riderskey = FirebaseDatabase.instance.ref().child("Riders").child(uid!);
DatabaseReference availableRider = FirebaseDatabase.instance.ref().child("availableRider").child(uid!);

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
        // :"/Riderdetails",
          : '/Main',
        routes: {
          // "/splash":(context) => SplashScreen(),
          "/onboarding": (context) => OnBoardingPage(),
          "/Main": (context) => MainScreen(),
          "/verify": (context) => OtpVerificationScreen(verificationId: '',),
          "/Riderdetails": (context) => Riderdetails(),
          "/hubtel": (context) => hubtelpay(),

          // "/SignUP": (context) => SignupPage(),
          "/authpage": (context) => AuthPage(),
          "/Homepage": (context) => homepage(),


        });
  }
}


