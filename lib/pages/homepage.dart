import 'dart:async';

import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import '../Models/Assistants/assistantmethods.dart';
import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../Models/appstate.dart';
import '../assistants/helper.dart';
import '../configMaps.dart';
import '../notifications/pushNotificationService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location_package;

import 'Authpage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.614818, -0.205874),
    zoom: 24.4746,
  );

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String? currentSelectedValue;

  final location = TextEditingController();

  @override
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapController;

  var geoLocator = Geolocator();
  GoogleMapController? _mapController;
  String driverStatusText = "Go Online ";

  Color driverStatusColor = Colors.white70;

  bool isDriverAvailable = false;
  bool isDriverActivated = false;
  // location_package.Location _location = location_package.Location();

  Set<Marker> markersSet = {};
  Position? _currentPosition;
  String? _currentAddress;
  String ArtisanStatusText = "Go Online ";

  Color ArtisanStatusColor = Colors.white70;

  double bottomPaddingOfMap = 0;

  @override
  void initState() {
    setState(() {
      Provider.of<helper>(context, listen: false).getCurrentLocation();
      Provider.of<helper>(context, listen: false).getAddressFromLatLng();
    });

    super.initState();
    locatePosition();

    // getPicture();
    AssistantMethod.getCurrentOnlineUserInfo(context);
    _requestLocationPermission();
    getCurrentArtisanInfo();
    requestLocationPermission();
    AssistantMethod.obtainTripRequestsHistoryData(context);
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission is granted, you can now access the location.
      // _getCurrentLocation();
    } else if (status.isDenied) {
      // Permission has been denied, show a snackbar or dialog to inform the user.
      // You can also open the device settings to allow the permission manually.
      openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied the permission. You may show a dialog
      // with a link to the app settings.
    }
  }

  void getLocationLiveUpdates() {
    double previousLatitude = 0.0;
    double previousLongitude = 0.0;
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser!.uid, position.latitude, position.longitude);
      }
      if (position.latitude != previousLatitude ||
          position.longitude != previousLongitude) {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));

        // Update the previous latitude and longitude for future comparisons
        previousLatitude = position.latitude;
        previousLongitude = position.longitude;
      }
      // LatLng latLng = LatLng(position.latitude, position.longitude);
      // newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }



  Future<void> locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Debug: Start checking location services
    print("Checking if location services are enabled...");

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    // Debug: Location services are enabled
    print("Location services are enabled.");

    // Check for location permissions
    print("Checking location permissions...");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied. Requesting permission...");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied again.");
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Debug: Location permissions granted
    print("Location permissions granted.");

    try {
      // Get the current position
      print("Getting the current location...");
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Current location: "
          "Latitude: ${_currentPosition?.latitude}, "
          "Longitude: ${_currentPosition?.longitude}");

      // Move the map camera to the current location
      LatLng currentLatLng =
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      CameraPosition cameraPosition = CameraPosition(target: currentLatLng, zoom: 14);

      print("Updating camera position...");
      if (_mapController != null) {
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        print("Camera position updated.");
      } else {
        print("Map controller is null. Unable to update camera position.");
      }
    } catch (e) {
      print("Error while fetching location or updating camera: $e");
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
      // await openAppSettings();
    }
  }

  getRideType() {
    Ridersdb.child(currentfirebaseUser!.uid)
        .child("car_details")
        .child("type")
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

  getRatings() {
    //update ratings
    Ridersdb.child(currentfirebaseUser!.uid)
        .child("ratings")
        .once()
        .then((value) {
      var dataSnapshot = value.snapshot;
      final map = dataSnapshot.value;

      if (dataSnapshot != null) {
        double ratings = double.parse(map.toString());
        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });

          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });

          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5.0) {
          setState(() {
            title = "Excellent";
          });

          return;
        }
      }
    });
  }

  getCurrentArtisanInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    Ridersdb.child(currentfirebaseUser!.uid).once().then((event) {
      print("value");
      if (event.snapshot.value is Map<Object?, Object?>) {
        riderinformation = Ride_r.fromMap(
            (event.snapshot.value as Map<Object?, Object?>)
                .cast<String, dynamic>());
      }

      // PushNotificationService pushNotificationService = PushNotificationService();
      // pushNotificationService.initialize(context);
      // pushNotificationService.getToken();
    });

    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethod.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission if it's denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If the permission is still denied after request
        return Future.error('Location permissions are denied');
      }
    }

    // If permission is permanently denied, handle it
    if (permission == LocationPermission.deniedForever) {
      // Location permission is permanently denied, handle it here
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Fetch and return the current location if permission is granted
    return await Geolocator.getCurrentPosition();
  }

  // Function to get current location
  Future<Position> _getCurrentLocation2() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // If permission is permanently denied, handle it
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }


// Function to reset the camera to the current location
  Future<void> _resetCamera() async {

    try {
      Position position = await _getCurrentLocation2();
      print("Current position: $position");

      if (newGoogleMapController != null) {
        newGoogleMapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      } else {
        print("GoogleMapController is null");
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.603111823223051, -0.18582144022941616),
    zoom: 14.4746,
  );
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
      compassEnabled: true,
      mapType: MapType.normal,
      myLocationButtonEnabled: false, // Custom button used instead
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controllerGoogleMap.complete(controller);
        _mapController = controller;
        locatePosition();
      },
    ),
    Positioned(
    top: 73,
    right: 20,
    child: FloatingActionButton(
      backgroundColor: Colors.white,
    onPressed: () async {
    locatePosition();
    },
    child: Icon(Icons.my_location),
    ),),
      //online offline driver Container
      Container(
        height: 140.0,
        width: double.infinity,
        //  color: Colors.black87,
      ),

      Positioned(
        top: 70.0,
        left: 0.0,
        right: 0.0,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.read<AppState>().driverStatusColor,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0),
                  )),
              onPressed: () async {
                final appState = context.read<AppState>();
                currentfirebaseUser = await FirebaseAuth.instance.currentUser;
                Riderskey.orderByChild("status").once().then((event) {
                  print('ecee$event');
                  var data = event.snapshot.value;
                  print('aaaa$data');
                  if (data == "deactivated") {
                    print('ssdsss$event');
                    displayToast("Sorry You are not Activated", context);
                    // DriverActivated();
                    //getLocationLiveUpdates();
                    appState.updateDriverStatus(
                        Colors.red, "Offline - Deactivated", false);

                    setState(() {
                      // driverStatusColor = Colors.red;
                      appState.updateDriverStatus(
                          Colors.red, "Offline - Deactivated", true);
                      // isDriverAvailable = false;
                    });
                  } else if (!appState.isDriverAvailable) {
                    // appState.updateDriverStatus(Colors.green, "Online", true);
                    makeRiderOnlineNow();
                    getLocationLiveUpdates();

                    //
                    setState(() {
                      // driverStatusColor = Colors.green;
                      // isDriverAvailable = true;
                      appState.updateDriverStatus(Colors.green, "Online", true);
                    });
                    displayToast("you are Online Now.", context);
                  } else {
                    makeRiderOfflineNow();
                    setState(() {
                      // appState.updateDriverStatus(Colors.white70, "Offline", false);
                      appState.updateDriverStatus(
                          Colors.white70, "Offline", false);

                      // driverStatusColor = Colors.white70;
                      // driverStatusText = "Offline ";
                      // isDriverAvailable = false;
                    });

                    displayToast("you are offline Now.", context);
                  }
                });
              },
              // bacolor: driverStatusColor,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      driverStatusText,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Icon(
                      Icons.online_prediction,
                      color: Colors.black,
                      size: 26.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
      Column(
        children: [
          SizedBox(
            height: 30,
          ),

          //
          // ])
        ],
      )
    ]);

    // bottomNavigationBar: (),
  }

  void makeRiderOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    print('cehcked  locations : $position');
    RiderRequestRef.set("searching");
    Geofire.initialize("availableRider");
    Geofire.setLocation(
      currentfirebaseUser!.uid,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    print('got current user after   locations : ${currentfirebaseUser?.uid}');
    // await availableRider.update(riderMap);
    RiderRequestRef.set("Searching");
    RiderRequestRef.onValue.listen((event) {});
  }

  Future<void> ArtisanActivated() async {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    RiderRequestRef.onDisconnect();
    RiderRequestRef.remove();

    displayToast("Sorry You are not Activated", context);
  }

  void makeRiderOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    RiderRequestRef.onDisconnect();
    RiderRequestRef.remove();
  }
}
