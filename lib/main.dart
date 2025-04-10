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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main()async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(); // Ensure permission is granted
getToken();
  saveFCMToken();// Save token when app starts
  setupFCMTokenListener();
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



    ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
    ),

    ChangeNotifierProvider<helper>(
      create: (context) => helper(),
    )

 // Listen for t
  ], child:MyApp())));
}
// Future<void> saveFCMToken() async {
//
//   String? token = await FirebaseMessaging.instance.getToken();
//   print("hwwwwre token");
//
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//   if (token != null && userId != null) {
//     await Ridersdb.update({
//       'token': token,
//     }).catchError((error) {
//       print("Error saving FCM token: $error");
//     });
//   }
final FirebaseMessaging messaging  = FirebaseMessaging.instance;

Future<void> getToken() async {
  try {
    String? token = await messaging.getToken();

    if (token == null) {
      print("Error: Failed to retrieve FCM token.");
      return;
    }

    print("This is token :: $token");

    if (currentfirebaseUser?.uid == null) {
      print("Error: User is not logged in.");
      return;
    }

    // Save token to Firebase Realtime Database
    await Ridersdb.child(currentfirebaseUser!.uid).child("token").set(token);

    print("FCM Token saved successfully.");

    // Subscribe to topics
    await messaging.subscribeToTopic("alldrivers");
    await messaging.subscribeToTopic("allusers");

    print("Subscribed to topics: alldrivers, allusers");
  } catch (e) {
    print("Error in getToken(): $e");
  }
}

// }
Future<void> saveFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token"); // Debugging: Print token

  if (token == null) {
    print("Error: Token is null. Ensure permissions are granted.");
    return;
  }

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    print("Error: User not logged in.");
    return;
  }

  await Ridersdb.update({
    'fcmToken': token,
  }).catchError((error) {
    print("Error saving FCM token: $error");
  });
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("Notification permission denied");
  } else {
    print("Notification permission granted");
    saveFCMToken(); // Fetch token after permission is granted
  }
}

void setupFCMTokenListener() {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    saveFCMToken(); // Save new token when it changes
  }).onError((err) {
    print("FCM Token Refresh Error: $err");
  });
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;



DatabaseReference  clientRequestRef = FirebaseDatabase.instance.ref().child("GasRequests");
DatabaseReference RiderRequestRef= FirebaseDatabase.instance.ref().child("Riders").child(uid!).child("new Rider");
DatabaseReference Ridersdb = FirebaseDatabase.instance.ref().child("Riders");
DatabaseReference Admindb = FirebaseDatabase.instance.ref().child("Admin");
DatabaseReference Clientsdb = FirebaseDatabase.instance.ref().child("Clients");
DatabaseReference Riderskey = FirebaseDatabase.instance.ref().child("Riders").child(uid!).child("status");
DatabaseReference availableRider = FirebaseDatabase.instance.ref().child("availableRider").child(uid!);


Future<String> getInitialRoute() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Fetch detailComp value from Firebase
  DatabaseEvent snapshot = await FirebaseDatabase.instance
      .ref()
      .child('Riders')
      .child(uid)
      .child('detailsComp')
      .once();

  bool? detailComp = snapshot.snapshot.value as bool?;

  if (FirebaseAuth.instance.currentUser == null) {
    return '/onboarding';

  } else if (detailComp == true) {
    return '/Main';
  } else {
    return '/Riderdetails'; // Navigate to Riderdetails if detailComp is false or not set
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(

                decoration: BoxDecoration(
                color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/images/delivery-with-white-background-1.png',
                      // Replace with your app's icon image path
                      width: 200,
                      height: 180,
                      // Optionally, you can add a color filter or other styling here
                    ),
                  ),
                    CircularProgressIndicator()
                ],),
              );  // Or a splash screen
        } else {
          String? initialRoute = snapshot.data;

          // Handle null case if necessary
          if (initialRoute == null) {
            initialRoute = '/onboarding'; // Or any default route you want to use
          }
          return MaterialApp(
            title: 'Filld Rider',
            theme: ThemeData(),
            debugShowCheckedModeBanner: false,
            initialRoute:initialRoute,

            //initialRoute,
            routes: {
              '/onboarding': (context) => OnBoardingPage(),
              '/Main': (context) => MainScreen(),
              '/verify': (context) => OtpVerificationScreen(verificationId: ''),
              '/Riderdetails': (context) => Riderdetails(),
              '/hubtel': (context) => hubtelpay(),
              '/authpage': (context) => AuthPage(),
              '/Homepage': (context) => homepage(),
            },
          );
        }
      },
    );
  }
  Widget routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return OnBoardingPage();
      case '/Main':
        return MainScreen();
      case '/verify':
        return OtpVerificationScreen(verificationId: '');
      case '/Riderdetails':
        return Riderdetails();
      case '/hubtel':
        return hubtelpay();
      case '/authpage':
        return AuthPage();
      case '/Homepage':
        return homepage();
      default:
        return Scaffold(
          body: Center(
            child: Text('Route not found: ${settings.name}'),
          ),
        );
    }
  }
}



class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or any background color you prefer
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        // App Icon

      // Circular Avatar (Example)
      CircularProgressIndicator()
      ],
    ),)
    ,
    );
  }




}
