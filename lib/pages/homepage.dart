import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../Models/otherUserModel.dart';
import '../configMaps.dart';
import '../notifications/pushNotificationService.dart';
import 'Authpage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String? currentSelectedValue;
  List<String> cylindertype = ["5kg", "9kg", "  12kg"];
  final _cylindertype = TextEditingController();
  final _emailController = TextEditingController();
  final location = TextEditingController();
  final _passwordController = TextEditingController();


  Position? _currentPosition;
  String? _currentAddress;
  String ArtisanStatusText = "Go Online ";

  Color ArtisanStatusColor = Colors.white70;
  bool isArtisanAvailable = false;
  bool isArtisanActivated = false;
  getartisanType() {
    RiderRequestRef
        .child(currentfirebaseUser!.uid)
        .child("service_type")
        .once()
        .then((value) {
      if (value != null) {
        print("Info got");
        setState(() {
          rideType = value.toString();
        });
      }
    });
  }


  getCurrentArtisanInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    Ridersdb.child(currentfirebaseUser!.uid).once().then((event) {
      print("value");
      if (event.snapshot.value != null) {
        riderinformation = Ride_r.fromSnapshot(event.snapshot);
      }

      PushNotificationService pushNotificationService = PushNotificationService();
      pushNotificationService.initialize(context);
      pushNotificationService.getToken();
    });

    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    // AssistantMethod.retrieveHistoryInfo(context);
    //getRatings();
    getartisanType();
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 30,
          ),


          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.0,left:70.0,right:20.0),
                child: Switch(
                  value: isSwitched,

                  onChanged: (value) async {
                    currentfirebaseUser =
                    await FirebaseAuth.instance.currentUser;


                    if (isSwitched == false) {
                      makeArtisanOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        isSwitched = true;
                      });
                      displayToast(" Online .", context);
                    } else {
                      makeArtisanOfflineNow();

                      setState(() {
                        isSwitched = false;

                        ArtisanStatusColor = Colors.white70;
                        ArtisanStatusText = "Offline ";
                        isArtisanAvailable = false;
                      });

                      displayToast("offline .", context);
                    };

                  },

                  activeTrackColor: Colors.black38,
                  activeColor: Colors.black,


                  // child: Padding(
                  //   padding: EdgeInsets.all(12.0),
                  //   child: Row(
                  //     mainAxisAlignment:
                  //     MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         HandyManStatusText,
                  //         style: TextStyle(
                  //             fontSize: 20.0,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.black),
                  //       ),
                  //       Icon(
                  //         Icons.online_prediction,
                  //         color: Colors.black,
                  //         size: 26.0,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
              ),
            ],
          ),


        ]),
      ),

      // bottomNavigationBar: (),
    );
  }
  void makeArtisanOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;


    Map<String, dynamic> artisanMap = {
      "Profilepicture": Provider.of<Users>(context, listen:false).userInfo!.profilepicture!,
      "client_name" :  Provider.of<Users>(context, listen:false).userInfo!.firstname!  +   Provider.of<Users>(context, listen:false).userInfo!.lastname!,
      "FirstName":Provider.of<Users>(context, listen:false).userInfo!.firstname!,
      "LastName":Provider.of<Users>(context, listen:false).userInfo!.lastname!,
      "service_type" :Provider.of<otherUsermodel>(context,listen:false).otherinfo!.Service!,
      "client_phone"  :Provider.of<Users>(context,listen:false).userInfo!.phone!,
      "Experience" :Provider.of<otherUsermodel>(context,listen: false).otherinfo!.Experience!,
      "Institution": Provider.of<otherUsermodel>(context,listen: false).otherinfo!.Institution!,
      "email":Provider.of<Users>(context,listen:false).userInfo!.email!,
      "Education":  Provider.of<otherUsermodel>(context,listen:false).otherinfo!.Education!,
      "Description": Provider.of<otherUsermodel>(context,listen:false).otherinfo!.Description!,
      "Location":Provider.of<otherUsermodel>(context,listen: false).otherinfo!.location??"",

    };
    RiderRequestRef.set("searching");
    Geofire.initialize("availableArtisans");
    Geofire.setLocation(
      currentfirebaseUser!.uid,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    await availableRider.update(artisanMap);

    RiderRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          currentPosition = position;

          if (isArtisanAvailable == true) {
            Geofire.setLocation(
                currentfirebaseUser!.uid, position.latitude, position.longitude);
          }

          // LatLng latLng = LatLng(position.latitude, position.longitude);
          // newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
        });
  }

  Future<void> ArtisanActivated() async {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    RiderRequestRef.onDisconnect();
    RiderRequestRef.remove();

    displayToast("Sorry You are not Activated", context);
  }

  void makeArtisanOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    RiderRequestRef.onDisconnect();
    RiderRequestRef.remove();
    //rideRequestRef= null;
    //return makeDriverOnlineNow();
    // _restartApp();
  }
}


