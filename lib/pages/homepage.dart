import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import '../Models/Assistants/assistantmethods.dart';
import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../Models/otherUserModel.dart';
import '../assistants/helper.dart';
import '../configMaps.dart';
import '../notifications/pushNotificationService.dart';
import 'package:permission_handler/permission_handler.dart';

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
  TextEditingController _locationController = TextEditingController();


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

  @override
  void initState() {
    setState(() {
      Provider.of<helper>(context, listen: false).getCurrentLocation();
      Provider.of<helper>(context, listen: false).getAddressFromLatLng();
    });


    super.initState();
    AssistantMethod.getCurrentOnlineUserInfo(context);
    AssistantMethod.getCurrentOnlineOtherUserInfo(context);
    //getPicture();
    // _checkGps();
    _requestLocationPermission();
    requestLocationPermission();
    AssistantMethod.getCurrentrequestinfo(context);
    AssistantMethod.obtainTripRequestsHistoryData(context);
    getCurrentArtisanInfo();

  }  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      List<Placemark> placemarks = await GeocodingPlatform.instance
          .placemarkFromCoordinates(position.latitude, position.longitude,
          localeIdentifier: "en");
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String placeName = placemark.name ?? ''; // Name of the place
        String locality = placemark.locality ?? ''; // City or locality
        String administrativeArea =
            placemark.administrativeArea ?? ''; // State or region

        String fullAddress = '$placeName, $locality, $administrativeArea';

        setState(() {
          _currentPosition = position;
          _locationController.text = fullAddress;
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      _getCurrentLocation();
    }
  }


  // Future _checkGps() async {
  //   if (!await location.serviceEnabled()) {
  //     location.requestService();
  //   }
  // }
  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission is granted, you can now access the location.
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Permission has been denied, show a snackbar or dialog to inform the user.
      // You can also open the device settings to allow the permission manually.
      openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied the permission. You may show a dialog
      // with a link to the app settings.
    }
  }
  Future<void> requestLocationPermission() async {
    final serviceStatusLocation = await Permission.locationWhenInUse.isGranted;

    bool isLocation =
        serviceStatusLocation == Permission.location.serviceStatus.isEnabled;

    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
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


