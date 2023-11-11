// import 'package:driver_app/AllScreens/loginScreen.dart';
// import 'package:driver_app/AllWidgets/ProfileInfo.dart';
// import 'package:driver_app/AllWidgets/Shimmer.dart';
//
// import 'package:driver_app/configMaps.dart';
// import 'package:driver_app/main.dart';
// import 'package:driver_app/tabPages/homeTabPage.dart';
import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';

import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../ProfileInfo.dart';
import '../configMaps.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:shimmer/shimmer.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: FutureBuilder(
        future: getPicture(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // return Center(
            //   child: const Text(
            //     "Something went wrong",
            //   ),
            //
            // );

            return Profile(context);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // context = snapshot.data as List;
            return Profile(context);
          }
          return Profile(context);
        },
      ),
    );







    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Shimmer.fromColors(
    //     baseColor: Colors.grey[300],
    //     highlightColor: Colors.grey[100],
    //     child: ListView.builder(itemBuilder: (BuildContext context, int index) => (
    //         Profile(context)
    //     ),
    //       itemCount: 10,
    //     ),
    //   ),
    //   //)
    // );
  }












  Widget Profile(BuildContext context){
    // var profile= Provider.of<Ride_r>(context, listen: false).profilepicture;
final rideprovider= Provider.of<Ride_r>(context).riderInfo;
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24.0,
              ),
              Center(
                child: Stack(children: [
                  Container(
                    child: CircleAvatar(
                        radius: 70,
                    backgroundImage:rideprovider?.profilepicture != null
                          ? NetworkImage(rideprovider!.profilepicture!)
                          : AssetImage("images/user_icon.png")as ImageProvider<Object>,
                           ),
                  ),
                ]),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                title + " driver",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  letterSpacing: 2.5,
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Text("${rideprovider?.firstname}"),
              //Text("${Riderskey.key}"),
              ProfileInfo(
                leading: '',
                title: rideprovider?.firstname,
                subtitle: 'Your Name',
              ),
              Divider(),
              ProfileInfo(
                leading: 'images/Vectormail.svg',
                title: rideprovider?.email,
                subtitle: 'Your Email',
              ),
              Divider(),
              // ProfileInfo(
              //   leading: 'images/fluent_vehicle-car-24-regularcar.svg',
              //   title:
              //   // title: riderinformation?.automobile_model +
              //   //     ", " +
              //   //     riderinformation.automobile_color +
              //                         riderinformation?.plate_number,
              //   subtitle: 'Vehichle Info',
              // ),
              Divider(),
              ProfileInfo(
                leading: 'images/26x26phone.svg',
                title: rideprovider?.phone,
                subtitle: 'Your phone number',
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                  onTap: () {
                    _showMyDialog(context);
                  },
                  child: Container(
                    height: 50.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        )),
                  )
              ),
            ],
          ),
        ),
      ),

    );
  }

  static Future<String> getPicture() async {
    User? user = await FirebaseAuth.instance.currentUser;
    return FirebaseDatabase.instance
        .ref()
        .child('Riders')
        .child(user!.uid)
        .once()
        .then((value) {
      var dataSnapshot = value.snapshot;
      final map = dataSnapshot.value as Map<dynamic, dynamic>;
      return map['riderImageUrl'].toString();
    });
  }
}


void _showMyDialog(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you certain you want to Sign Out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                print('yes');
                Geofire.removeLocation(currentfirebaseUser!.uid);
                RiderRequestRef.onDisconnect();
                RiderRequestRef.remove();
                // RiderRequestRef = "";

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/authpage', (route) => false);
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

