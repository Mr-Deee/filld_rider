import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:filld_rider/Models/address.dart';
import 'package:filld_rider/Models/directDetails.dart';
import 'package:filld_rider/assistants/requestAssistant.dart';
import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Ride_r.dart';
import 'package:filld_rider/Models/history.dart';
import 'package:http/http.dart' as http;

import '../../DataHandler/appData.dart';
import '../../configMaps.dart';
import '../Users.dart';
// import '../otherUserModel.dart';

class AssistantMethod{

  static Future<Map<String, dynamic>> loadServiceAccountKey() async {
    try {
      // Reading from the file system, adjust the path as needed
      final file = File('assets/firebase_service_account.json');

      final String jsonString = await rootBundle.loadString('assets/firebase_service_account.json');
      final content = await jsonString; // Read the file as a string
      return jsonDecode(content); // Parse the JSON content into a Map
    } catch (e) {
      print('Error loading service account key: $e');
      throw e;
    }
  }

  static Future<AccessCredentials> _getAccessToken() async {
    try {
      final serviceAccountKey = await loadServiceAccountKey();

      // Use googleapis_auth to obtain credentials
      final accountCredentials = ServiceAccountCredentials.fromJson(
          serviceAccountKey);
      final scopes = [
        'https://www.googleapis.com/auth/firebase.messaging' // Add FCM scope
      ];

      final authClient = await clientViaServiceAccount(
          accountCredentials, scopes);
      return authClient.credentials; // Return the access credentials
    } catch (e) {
      print('Error obtaining access token: $e');
      throw e;
    }
  }
  static const String projectId = 'fill-d-db8f7';  // Your Firebase project ID
  static const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
  static sendNotificationriderarrived(String token, context, String ride_request_id) async {
    try {
      final credentials = await _getAccessToken();
      final accessToken = credentials.accessToken.data;

    Map<String, dynamic> notification = {
      'message': {
        'token': token,
        'notification': {
          'body': 'Rider is outside Kindly  make your cylinder available',
          'title': 'Rider Has Arrived At Your Location'
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'ride_request_id': ride_request_id,
        },
      }
    };


      final response = await http.post(
      Uri.parse(fcmEndpoint),
    headers: {
    HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
    print('Notification sent successfully.');
    } else {
    print('Failed to send notification. Error: ${response.body}');
    }
    } catch (e) {
    print('Error sending notification: $e');
    }


  }
  static sendNotificationjobstarted(String token, context, String ride_request_id) async {
    try {
      final credentials = await _getAccessToken();
      final accessToken = credentials.accessToken.data;

    Map notificationMap = {
      'body': 'Your Delivery Just Started',
        'title': 'Your Gas will be "Filld" shortly'
    };
      // FCM HTTP v1 API payload
      Map<String, dynamic> notification = {
        'message': {
          'token': token,
          'notification': {
            'body': 'Your Delivery Just Started',
            'title': 'Your Gas will be "Filld" shortly'
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'ride_request_id': ride_request_id,
          },
        }
      };



    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  } catch (e) {
  print('Error sending notification: $e');
  }
  }
  static sendNotificationrideronthewaytofillgas(String token, context, String ride_request_id) async {
       try {
      final credentials = await _getAccessToken();
      final accessToken = credentials.accessToken.data;

      Map<String, dynamic> notification = {
        'message': {
          'token': token,
          'notification': {
            'body': 'Rider is on the way to fill your cylinder',
            'title': 'New Delivery Request'
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'ride_request_id': ride_request_id,
          },
        }
      };




      final response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
      } else {
        print('Failed to send notification. Error: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  //arrived at gas station
  static sendNotificationriderarrivedatgasstation(String token, context, String ride_request_id) async {
    // var destination =
    //     Provider.of<AppData>(context, listen: false).dropOfflocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Rider is at the Gas Station',
        'title': 'Your Gas is being field'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      // 'ride_request_id': "ride_request_id",
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }








  static sendNotificationforredecompleted(String token, context, String ride_request_id) async {
    // var destination =
    //     Provider.of<AppData>(context, listen: false).dropOfflocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Rider is has completed',
        'title': 'Gas delivery Successful'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      // 'ride_request_id': "ride_request_id",
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }


  static void getCurrentOnlineUserInfo(BuildContext context) async {
    print('assistant methods step 3:: get current online user info');
    firebaseUser = FirebaseAuth.instance.currentUser; // CALL FIREBASE AUTH INSTANCE
    print('assistant methods step 4:: call firebase auth instance');
    String? userId = firebaseUser!.uid; // ASSIGN UID FROM FIREBASE TO LOCAL STRING
    print('assistant methods step 5:: assign firebase uid to string');
    print(userId);
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Riders").child(userId);
    print(
        'assistant methods step 6:: call users document from firebase database using userId');
    reference.once().then(( event) async {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value!= null) {
        print(
            'assistant methods step 7:: assign users data to usersCurrentInfo object');

        DatabaseEvent event = await reference.once();
        print(event);

        context.read<Ride_r>().setRider(Ride_r.fromMap(Map<String, dynamic>.from(event.snapshot.value as dynamic)));
        print('assistant methods step 8:: assign users data to usersCurrentInfo object');
        print(Users().firstname);

      }
    }
    );






  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms of GHS
    double timeTravelFare = (directionDetails.durationValue! / 60) * 0.20;
    double distanceTraveledFare = (directionDetails.distanceValue! / 1000) *
        0.20;
    double totalFareAmount = timeTravelFare + distanceTraveledFare;

    //1$ = 5.76
    double totalLocalAmount = totalFareAmount * 160;

    if (rideType == "Rev-x") {
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    }
    else if (rideType == "Rev-Executive") {
      return totalFareAmount.truncate();
    }
    else if (rideType == "Rev-standard") {
      double result = (totalFareAmount.truncate()) / 2.0;
      return result.truncate();
    }
    else {
      return totalFareAmount.truncate();
    }
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void obtainTripRequestsHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
    {
      clientRequestRef.child(key).once().then((event) {

        print("newevent:$event");
        // var dataSnapshot = event.snapshot;
        // final map = dataSnapshot.value ;
        if( event.snapshot.value!= null)
        {
          history = History.fromSnapshot(event.snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
        }
      });
    }
  }



  static Future<void> retrieveHistoryInfo(context)
  async {


    Ridersdb.child(currentfirebaseUser!.uid).child("earnings").once().then((
        event) {

      // var dataSnapshot = value.snapshot;
      // final map = dataSnapshot.value as Map<dynamic, dynamic>;
      if( event.snapshot.value!= null){
        String earnings = event.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);

        print("earnings:$earnings");
      }
    });
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No current user found");
      return;
    }

    String userId = currentUser.uid;
    String? firstName;
    await Ridersdb.child(userId).once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userMap = event.snapshot.value as Map<dynamic, dynamic>;
        firstName = userMap['FirstName'];
      }
    });

    if (firstName == null) {
      print("First name not found for user");
      return;
    }


    //retrieve and display Trip History
    clientRequestRef.orderByChild("driver_name").equalTo(firstName).once().then((event)
    {

      final dataSnapshot = event.snapshot;
      if(dataSnapshot.value != null)
      {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> keys = dataSnapshot.value as Map<dynamic, dynamic>;

        print('assistant methods step 84::{}');
        print("haya${firstName}");
        //update total number of trip counts to provider
        // Map<dynamic, dynamic> keys = dataSnapshot as Map;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);
        print('assistant methods step 84::{}');
        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value)
        {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
      }
    });
  }






  static void disableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription?.pause();
    Geofire.removeLocation(currentfirebaseUser!.uid);
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition
        .latitude},${initialPosition.longitude}&destination=${finalPosition
        .latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
    res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
    res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
    res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
    res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
    res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }


  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }



  // Future<void> sendNotificationToClient(String clientToken, String message) async {
  //   final String serverToken = 'YOUR_SERVER_KEY';  // Replace with your server key
  //
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$serverToken',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'body': message,
  //           'title': 'Ride Update'
  //         },
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'status': 'done'
  //         },
  //         'to': clientToken,
  //       }),
  //     );
  //   } catch (e) {
  //     print("Error sending notification: $e");
  //   }
  // }
}