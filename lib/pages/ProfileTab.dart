import 'package:filld_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';
import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../ProfileInfo.dart';
import '../configMaps.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),

        ),
      ),
      body: FutureBuilder(
        future: getPicture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Profile(context);
          }
          return Profile(context); // You might want to handle other states
        },
      ),
    );
  }

  Widget Profile(BuildContext context) {
    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24.0),
              Center(
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 4, // Add elevation for a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(106), // Rounded corners
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: rideprovider?.profilepicture != null
                              ? NetworkImage(rideprovider!.profilepicture!)
                              : AssetImage("assets/images/user_icon.png") as ImageProvider<Object>,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 28.0),
          Card(
            color: Colors.white,
            elevation: 4, // Add elevation for a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            child: Column(
              children: [

                ProfileInfo(
                  leading: Icons.person,
                  title: rideprovider?.firstname,
                  // subtitle: 'Your Name',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30),
                  child: Divider(),
                ),
                ProfileInfo(
                  leading: Icons.email,
                  title: rideprovider?.email,
                  // subtitle: 'Your Email',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30),
                  child: Divider(),
                ),
                ProfileInfo(
                  leading: Icons.phone,
                  title: rideprovider?.phone,
                  // subtitle: 'Your phone number',
                ),
                // Divider(),
                SizedBox(height: 2.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showMyDialog(context);
                    },
                    child: Container(
                      height: 50.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )


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
    barrierDismissible: false,
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
              Geofire.removeLocation(currentfirebaseUser!.uid);
              RiderRequestRef.onDisconnect();
              RiderRequestRef.remove();
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/authpage', (route) => false);
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
    },
  );
}
