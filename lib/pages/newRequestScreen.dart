import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../CollectFareDialog.dart';
import '../Models/Assistants/assistantmethods.dart';
import '../Models/Assistants/mapKitAssistant.dart';
import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../Models/clientDetails.dart';
import '../Models/hubtelpay.dart';
import '../configMaps.dart';
import '../main.dart';
import '../progressDialog.dart';

class NewRequestScreen extends StatefulWidget {
  final ClientDetails clientDetails;

  NewRequestScreen({required this.clientDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  double _width = 70;
  double _height = 70;
  String? facts ="";

  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(10);
  final phonecontroller = TextEditingController();

  bool _isCollapsed = false;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newRideGoogleMapController;
  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions =
      LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor? animatingMarkerIcon;
  Position? myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.white;
  StreamSubscription<DatabaseEvent>? rideStreamSubscription;
  bool _isSending = false;

  final String clientId = 'ttuouezo';
  final String clientSecret = 'wxyewyap';
  final String sender = "Fill'D";
  Timer? timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();

    acceptRideRequest();
  }

  void listenForStatusChanges() {
    String? rideRequestId = widget.clientDetails.ride_request_id;
    DatabaseReference statusRef = clientRequestRef.child(rideRequestId!).child("status");

    rideStreamSubscription = statusRef.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value.toString() == "cancelled") {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User has cancelled the ride.')));
      }
    });
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/tools.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);

    // rideStreamSubscription =
    Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPostion = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, myPosition?.latitude, myPosition?.latitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPostion,
        icon: animatingMarkerIcon!,
        rotation: rot as double,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPostion, zoom: 17);
        newRideGoogleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet
            .removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });
      oldPos = mPostion;
      updateRideDetails();

      String? rideRequestId = widget.clientDetails.ride_request_id;
      Map locMap = {
        "latitude": currentPosition?.latitude.toString(),
        "longitude": currentPosition?.longitude.toString(),
      };
      clientRequestRef
          .child(rideRequestId!)
          .child("driver_location")
          .set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isColapsed;
    createIconMarker();
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition: NewRequestScreen._kGooglePlex,
        myLocationEnabled: true,
        markers: markersSet,
        circles: circleSet,
        polylines: polyLineSet,
        onMapCreated: (GoogleMapController controller) async {
          _controllerGoogleMap.complete(controller);
          newRideGoogleMapController = controller;
          setState(() {
            mapPaddingFromBottom = 265.0;
          });

          var currentLatLng =
              LatLng(currentPosition!.latitude, currentPosition!.longitude);
          var pickUpLatLng = widget.clientDetails.pickup;

          await getPlaceDirection(currentLatLng, pickUpLatLng!);

          getRideLiveLocationUpdates();
        },
      ),
      Positioned(
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
          child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  height: 220.0,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Text(
                          durationRide,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 26.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.clientDetails.client_name ?? "",
                              style: TextStyle(
                                  fontFamily: "Brand Bold", fontSize: 19.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.motorcycle),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/pickup.png", height: 26.0,
                              width: 16.0,),
                            SizedBox(
                              width: 18.0,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  widget.clientDetails.pickup_address ?? "",
                                  style: TextStyle(fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/location.png", height: 16.0,
                              width: 16.0,),
                            SizedBox(
                              width: 18.0,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  widget.clientDetails.dropoff_address ?? "",
                                  style: TextStyle(fontSize: 10.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            // ignore: deprecated_member_use
                            child:ElevatedButton(
                              onPressed: () async {
                                String? rideRequestId = widget.clientDetails.ride_request_id;

                                if (rideRequestId == null) {
                                  print("Ride Request ID is null");
                                  return;
                                }

                                // Get client_id using rideRequestId
                                DatabaseReference? rideIdRef = clientRequestRef.child(rideRequestId).child("client_id");

                                rideIdRef.once().then((DatabaseEvent event) {
                                  if (event.snapshot.value != null) {
                                    String clientId = event.snapshot.value.toString();

                                    // Get clientToken using clientId
                                    Clientsdb.child(clientId).child("token").once().then((event) async {
                                      final snap = event.snapshot;
                                      String? clientToken = snap.value as String?;

                                      if (clientToken != null) {
                                        if (status == "accepted") {
                                          // Status change: "arrived"
                                          status = "arrived";
                                          await clientRequestRef.child(rideRequestId).child("status").set(status);

                                          setState(() {
                                            btnTitle = "Start Job";
                                            btnColor = Colors.lightGreenAccent;
                                          });

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) => ProgressDialog(
                                              message: "Please wait...",
                                            ),
                                          );

                                          await getPlaceDirection(widget.clientDetails.pickup!, widget.clientDetails.dropoff!);
                                          Navigator.pop(context);

                                          await AssistantMethod.sendNotificationriderarrived(clientToken, "Your ride has arrived!", rideRequestId);

                                        } else if (status == "arrived") {
                                          // Status change: "returning"
                                          status = "returning";
                                          await clientRequestRef.child(rideRequestId).child("status").set(status);

                                          setState(() {
                                            btnTitle = "Arrived At Gas Station";
                                            btnColor = Colors.redAccent;
                                            // _handleRiderActivation();
                                          });

                                          initTimer();

                                        } else if (status == "returning") {
                                          // New Status change: "arrived_at_gas_station"
                                          status = "arrived_at_gas_station";
                                          await clientRequestRef.child(rideRequestId).child("status").set(status);

                                          setState(() {
                                            btnTitle = "Complete Delivery";
                                            btnColor = Colors.greenAccent;
                                          });


                                          await AssistantMethod.sendNotificationriderarrived(clientToken, "Driver has arrived at the gas station!", rideRequestId);

                                          print("THIS IS CLIENT TOKEN22: $clientToken");
                                          //
                                          _handleRiderActivation();
                                        } else if (status == "arrived_at_gas_station") {

                                          // Status change: "completed"
                                          status = "completed";
                                          await clientRequestRef.child(rideRequestId).child("status").set(status);

                                          await getPlaceDirection2(widget.clientDetails.dropoff!, widget.clientDetails.pickup!);
                                          fetchFacts();

                                          setState(() {
                                            btnTitle = "End Trip";
                                            btnColor = Colors.blueAccent;
                                          });

                                          print("THIS IS CLIENT TOKEN: $clientToken");

                                        } else if (status == "completed") {
                                          // Status: "end the trip"
                                          await clientRequestRef.child(rideRequestId).child("status").set(status);
                                          await AssistantMethod.sendNotificationforredecompleted(clientToken, "Delivery has been completed!", rideRequestId);

                                          setState(() {
                                            btnTitle = "End Trip";
                                            btnColor = Colors.blueAccent;
                                          });

                                          endTheTrip();
                                        }
                                      } else {
                                        print("Client token is null");
                                      }
                                    }).catchError((error) {
                                      print("Failed to retrieve client token: $error");
                                    });

                                  } else {
                                    print("Client ID is null");
                                  }
                                }).catchError((error) {
                                  print("Failed to retrieve client ID: $error");
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        btnTitle,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Icon(
                                        Icons.sports_motorsports,
                                        color: Colors.black,
                                        size: 26.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    side: const BorderSide(color: Colors.white)),
                              ),
                            )




                        ),
                      ]),
                    ),
                  ))))
    ]));
  }

  void _handleRiderActivation() {
    print("Rider activation started");
    final phoneNumber ='+233548498844';
    final rideprovider = Provider.of<Ride_r>(context,listen: false).riderInfo;
    print("Rider activation started1.1");
    final Clientname = widget.clientDetails.client_name.toString();
    print("Rider activation started2");
    final Riderfname = rideprovider?.firstname.toString();
    final Riderlname = rideprovider?.lastname.toString();
    final FareAmount = widget.clientDetails.GasFare;
    print("Rider activation started3");
    final gaslocation = widget.clientDetails.dropoff_address;
    print('here$Clientname');
    final String message    = "Hi there, your rider with name  "
        "${Riderfname} ${Riderlname}, is at the ${gaslocation} Gas Station ."
        'Kindly pay this amount: ${FareAmount} for the refill  ';
        // "Thank you for delivering with Fill'D.";
    if (phoneNumber.isNotEmpty && message.isNotEmpty) {
      sendSms(phoneNumber, message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
    // _sendActivationWebEmail(rider.email);
    //_editRiderStatus(rider);
    // Navigator.of(context).pop();
  }



  Future<void> sendSms(String phoneNumber, String message) async {
    setState(() {
      _isSending = true;
    });

    final url = Uri.parse('https://sms.hubtel.com/v1/messages/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "From": sender,
          "To": phoneNumber,
          "Content": message,
          "RegisteredDelivery": true,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "SMS sent successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "SMS sent successfully!",
          // toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.BOTTOM,
        );
        // Fluttertoast.showToast(
        //   msg: "Failed to send SMS: ${response.body}",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      }

    }
    // catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: $e')),
    //   );
    // }
    finally {
      setState(() {
        _isSending = false;
      });
    }
  }







  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    polylineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.black,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newRideGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.black,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }
  Future<void> getPlaceDirection2(LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));

    var details = await AssistantMethod.obtainPlaceDirectionDetails(
        dropOffLatLng, pickUpLatLng,);

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    polylineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.black,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newRideGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.black,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }
  void acceptRideRequest() {

    final rideprovider= Provider.of<Ride_r>(context,listen: false).riderInfo;
    String? rideRequestId = widget.clientDetails.ride_request_id;
    clientRequestRef.child(rideRequestId!).child("status").set("accepted");
    clientRequestRef.child(rideRequestId).child("driver_name").set(
        rideprovider?.firstname );
    clientRequestRef.child(rideRequestId).child("driver_phone").set(
        rideprovider?.phone);

    clientRequestRef.child(rideRequestId).child("driver_id").set(
        Riderskey.key);
    clientRequestRef.child(rideRequestId).child("car_details").set(
        '${rideprovider?.automobile_color} ● ${rideprovider
            ?.automobile_model} ● ${rideprovider?.plate_number}'
    );


    clientRequestRef.child(rideRequestId).child("profilepicture").set(
        rideprovider?.profilepicture);


    Map locMap =
    {
      "latitude": currentPosition?.latitude.toString(),
      "longitude": currentPosition?.longitude.toString(),
    };
    clientRequestRef.child(rideRequestId).child("driver_location").set(locMap);

    RiderRequestRef.child(currentfirebaseUser!.uid).child("history").child(
        rideRequestId).set(true);
  }

  Future<void> ShowPrompt() async {
    // var currentLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
    //
    // var directionalDetails = await AssistantMethod.obtainPlaceDirectionDetails(
    //     widget.clientDetails.pickup!, currentLatLng);
    //
    // int fareAmount = AssistantMethod.calculateFares(directionalDetails!);
    //
    String? rideRequestId = widget.clientDetails.ride_request_id;

    // Show a prompt to enter a number
    String? transactionId = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Send"),
        content: Text("Send"),

        // TextFormField(
        //   keyboardType: TextInputType.number,
        //   controller: phonecontroller,
        //   decoration: InputDecoration(labelText: "Gas Station N.O"),
        // ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
               clientRequestRef.child(rideRequestId!).child("GasStationNum").set(phonecontroller.text.toString());
               print(phonecontroller);
               // notifyClient(rideRequestId);
               // // clientRequestRef.child(rideRequestId!).child("status").set("phonecontroller");

              // Navigator.pop(context, transactionIdController.text);
            },
            child: Text("Send"),
          ),
        ],
      ),
    );


  }
  final FirebaseMessaging messaging  = FirebaseMessaging.instance;

  Future getToken() async {
    String? token = await messaging.getToken();
    print("This is token :: ");
    print(token);
    Admindb.child(currentfirebaseUser!.uid).child("token").set(token);
    print("JUST GOT IT");
    messaging.subscribeToTopic("alldrivers");
    messaging.subscribeToTopic("allusers");
  }

  void notifyClient(String rideRequestId) {
    String? rideRequestId = widget.clientDetails.ride_request_id;
print(rideRequestId);
    DatabaseReference? rideIdRef = clientRequestRef.child(rideRequestId!).child("client_id");

    // Use once() to get the client_id from the database
    rideIdRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        String clientId = event.snapshot.value.toString();

        // Set the "GasCompany" field in Clientsdb using the retrieved client_id
        Clientsdb.child(clientId).child("GasCompany").set(rideRequestId);

        // Now, you can use clientId for any further processing
        // ...

        // Retrieve client's email
        Clientsdb.child(clientId).child("token").once().then((event) {
          print("wants to send");
          final snap = event.snapshot;
          if (snap.value != null) {
            String token = snap.value.toString();
            print("wants to send2");
            // Send notification to the client
            // AssistantMethod.sendNotificationToClient(token, context, rideRequestId);
            print("wants to send3");
            print('waaa:$rideRequestId');
          } else {
            // Handle the case where the client's email is not available
            return;
          }
        });
      } else {
        // Handle the case where client_id is not available
        return;
      }
    });
  }



  void updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }
      //this the drivers position
      var posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng? destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = widget.clientDetails.pickup;
      } else {
        destinationLatLng = widget.clientDetails.dropoff;
      }

      var directionDetails = await AssistantMethod.obtainPlaceDirectionDetails(
          posLatLng, destinationLatLng!);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText!;
        });
      }

      isRequestingDirection = false;
    }
  }
  void updateRideDetails2() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }
      //this the drivers position
      var posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng? destinationLatLng;

      if (status == "continue") {
        destinationLatLng = widget.clientDetails.pickup;
      } else {
        destinationLatLng = widget.clientDetails.dropoff;
      }

      var directionDetails = await AssistantMethod.obtainPlaceDirectionDetails(
          posLatLng, destinationLatLng!);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText!;
        });
      }

      isRequestingDirection = false;
    }
  }

  // }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  endTheTrip() async {
    timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var currentLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);

    var directionalDetails = await AssistantMethod.obtainPlaceDirectionDetails(
        widget.clientDetails.pickup!, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethod.calculateFares(directionalDetails!);

    String? rideRequestId = widget.clientDetails.ride_request_id;
    clientRequestRef
        .child(rideRequestId!)
        .child("fares")
        .set(fareAmount.toString());
    clientRequestRef.child(rideRequestId).child("status").set("ended");
    rideStreamSubscription?.cancel();


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CollectFareDialog(
        paymentMethod: widget.clientDetails.payment_method,
        fareAmount: fareAmount,
      ),
    );

    saveEarnings(fareAmount);
  }
SendPrompt() async{

  var currentLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);

  var directionalDetails = await AssistantMethod.obtainPlaceDirectionDetails(
      widget.clientDetails.pickup!, currentLatLng);


  int fareAmount = AssistantMethod.calculateFares(directionalDetails!);

  String? rideRequestId = widget.clientDetails.ride_request_id;

  clientRequestRef.child(rideRequestId!).child("status").set("At Gas Station");




  saveEarnings(fareAmount);

}
  void saveEarnings(int fareAmount) {
    Ridersdb
        .child(currentfirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((event) {
      if (event != null) {
        double oldEarnings = double.parse(event.toString());
        double totalEarnings = fareAmount + oldEarnings;

        Ridersdb
            .child(currentfirebaseUser!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();
        Ridersdb
            .child(currentfirebaseUser!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }

  Future<void> fetchFacts() async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/facts?limit=1');
    final headers = {'X-Api-Key': 'C6I2OTzM2wctRCE6KKi8sQ==SYJVNnpVrCDaY5rE'};

    final response = await http.get(url, headers: headers);

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('jsonData: $jsonData');
        final data  = jsonData[0]['fact'] ;

        print('Type of data: ${data.runtimeType}');
        print('Value of data: $data');

        setState(() {
          facts = data;
        });
        // _showFactDialog();
      } else {
        throw Exception('Failed to load facts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sendNotificationToAdmin() {
    String deliveryPrice = "20"; // Replace with actual delivery price
    String gasPrice = "5"; // Replace with actual gas price
    String location = "Gas Station XYZ"; // Replace with actual location

    notifyAdmin(deliveryPrice, gasPrice, location);
  }

  void notifyAdmin(String deliveryPrice, String gasPrice, String location) async {
    String adminToken = Admindb.child(currentfirebaseUser!.uid).child("token") as String; // Replace with the actual FCM token of the admin

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': serverToken, // Replace with your server key
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Delivery Price: $deliveryPrice, Gas Price: $gasPrice, Location: $location',
              'title': 'Delivery Update'
            },
            'priority': 'high',
            'to': adminToken,
          },
        ),
      );
      print('Notification sent to admin');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }







}
