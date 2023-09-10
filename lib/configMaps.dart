import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'Models/Ride_r.dart';
import 'Models/Users.dart';
// import 'Models/arti_san.dart';
import 'package:geolocator/geolocator.dart';


// String mapKey ="AIzaSyALq45ym3PbPzoeBB8ULxsVdQ2VSRFWWuQ";
String mapKey ="AIzaSyC6UDM8O3wlMa5SNLHfcM8MGEFJ3ejc55U";


// Arti_san? artisanInformation;
Ride_r? riderinformation;
//User firebaseUser;

Users? userCurrentInfo; // CURRENT USER INFO

Position ?currentPosition;

User? currentUser;

String title="";
double starCounter=0.0;

StreamSubscription<Position>?  homeTabPageStreamSubscription;
String rideType="";
String serverToken = "key=AAAAH236CYE:APA91bHTCNVNDzYg7z3gZ57sA7FBSt4fWMm0zp3w_3pc6PjUR4SbG4sJPRFCz07wBTY3fA1zNx3iDorEU-Ia1QRP5jmcYTbsAEitjbZbuw2jOLx7SUBioiBnIIFAuV7BqHWjVk89UhGH";