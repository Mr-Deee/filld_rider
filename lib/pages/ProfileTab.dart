import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import '../Models/Ride_r.dart';
import '../Models/Users.dart';
import '../main.dart';
import 'CSS.dart';

class ProfileTabPage extends StatefulWidget {
  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  bool _isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController motorBrandController = TextEditingController();
  final TextEditingController motorColorController = TextEditingController();
  final TextEditingController riderImageUrlController = TextEditingController();
  final TextEditingController riderLicenseController = TextEditingController();
  final TextEditingController riderGhanaCard = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'My Profile',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //   ),
      //   actions: [
      //     // _isEditing
      //     //     ? Padding(
      //     //         padding: const EdgeInsets.only(right: 18.0),
      //     //         child: GestureDetector(
      //     //           onTap: () {
      //     //             _saveProfile(
      //     //                 nameController.text,
      //     //                 phoneController.text,
      //     //                 motorBrandController.text,
      //     //                 riderImageUrlController.text,
      //     //                 riderLicenseController.text,
      //     //                 riderGhanaCard.text,
      //     //                 context);
      //     //             setState(() {
      //     //               _isEditing = false;
      //     //             });
      //     //           },
      //     //           child: Icon(Icons.save),
      //     //         ),
      //     //       )
      //     //     : Padding(
      //     //         padding: const EdgeInsets.only(right: 28.0),
      //     //         child: GestureDetector(
      //     //           onTap: () {
      //     //             setState(() {
      //     //               _isEditing = true;
      //     //             });
      //     //           },
      //     //           child: Icon(Icons.edit),
      //     //         ),
      //     //       ),
      //     GestureDetector(
      //       onTap: () {
      //         _showMyDialog(context);
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 18.0),
      //         child: Center(
      //           child: Icon(Icons.logout),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: FutureBuilder(
        future: getPicture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Profile(context);
          }
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while fetching data
        },
      ),
    );
  }

  Widget Profile(BuildContext context) {
    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    var username = rideprovider?.firstname;
    var email = rideprovider?.email;
    var phone = rideprovider?.phone;
    nameController.text = rideprovider?.firstname ?? '';
    emailController.text = rideprovider?.email ?? '';
    phoneController.text = rideprovider?.phone ?? '';
    motorBrandController.text = rideprovider?.automobile_model ?? '';
    motorColorController.text = rideprovider?.automobile_model ?? '';
    riderLicenseController.text = rideprovider?.plate_number ?? '';
    riderGhanaCard.text = rideprovider?.GhanaCard ?? '';
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Match the border radius
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Strong blur effect
                                child:  Container(
                                  height: 380,
                                  width: 900,


                                    decoration: BoxDecoration(
                                    // image: DecorationImage(
                                    //   image: AssetImage("assets/images/backdrop.jpg"),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    borderRadius: BorderRadius.circular(10),
                                      color: Colors.blueAccent.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 70,
                              right: 120,
                              left: 120,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: rideprovider?.profilepicture != null
                                    ? CachedNetworkImageProvider(
                                  rideprovider!.profilepicture!,
                                )
                                    : AssetImage("assets/images/user_icon.png")
                                as ImageProvider<Object>,
                              ),
                            ),
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 140), // Adjust to position the texts below the image
                                  Text(
                                    '$username',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 8), // Spacing between username and email
                                  Text(
                                    '$email',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 8), // Spacing between username and email
                                  Text(
                                    '$phone',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // SizedBox(height: 60.0),
                      // Card(
                      //   color: Colors.white,
                      //   elevation: 4, // Add elevation for a shadow effect
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius:
                      //         BorderRadius.circular(16), // Rounded corners
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       // ProfileInfo(
                      //       //   leading: Icons.person,
                      //       //   controller: nameController,
                      //       //   label: "Name",
                      //       //   isEditing: _isEditing,
                      //       // ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.only(left: 30, right: 30),
                      //         // child: Divider(),
                      //       ),
                      //       ProfileInfo(
                      //         leading: Icons.email,
                      //         controller: emailController,
                      //         label: "Email",
                      //         isEditing: false,
                      //       ),
                      //       SizedBox(height: 8.0),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.only(left: 30, right: 30),
                      //         child: Divider(),
                      //       ),
                      //       SizedBox(height: 8.0),
                      //       ProfileInfo(
                      //         leading: Icons.phone,
                      //         controller: phoneController,
                      //         label: "Phone",
                      //         isEditing: _isEditing,
                      //       ),
                      //       SizedBox(height: 10.0),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 19),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 4, // Add elevation for a shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                          ),
                          child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CustomerSupportService()),
                                );
                              },
                              child: Row(

                                children: [
                                  SizedBox(height:12.0),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Icon(Icons.call),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Customer Support Service"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height:6.0),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 30, right: 30),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.info),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("About"),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 30, right: 30),
                              child: Divider(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.info),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Privacy Policy"),
                                ),
                              ],
                            )

                          ],
                        ),),
                      )
                      //   Text("Other Details",style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 1.0),
                      // ProfileInfo(
                      //   leading: Icons.motorcycle,
                      //   controller: motorBrandController,
                      //   label: "Motor Brand",
                      //   isEditing: _isEditing,
                      // ),
                      // SizedBox(height: 8.0),
                      // ProfileInfo(
                      //   leading: Icons.image,
                      //   controller: riderGhanaCard,
                      //   label: "Rider GH Card",
                      //   isEditing: _isEditing,
                      // ),
                      // SizedBox(height: 8.0),
                      // ProfileInfo(
                      //   leading: Icons.file_copy,
                      //   controller: riderLicenseController,
                      //   label: "Rider License URL",
                      //   isEditing: _isEditing,
                      // ),
                    ]))));
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

  void _saveProfile(
      String name,
      String phone,
      String motorBrand,
      String riderImageUrl,
      String riderLicense,
      String riderGhanaCard,
      BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance.ref().child('Riders').child(user!.uid).update({
      'firstname': name,
      'phoneNumber': phone,
      'car_details': {
        'motorBrand': motorBrand,
        'riderImageUrl': riderImageUrl,
        'licensePlateNumber': riderLicense,
        'GhanaCardNumber': riderLicense,
      },
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update profile')));
    });
  }
}

class ProfileInfo extends StatelessWidget {
  final IconData leading;
  final TextEditingController controller;
  final String label;
  final bool isEditing;

  ProfileInfo({
    required this.leading,
    required this.controller,
    required this.label,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(leading, color: Colors.black54),
          SizedBox(width: 20.0),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )
                : Text(
                    controller.text,
                    style: TextStyle(fontSize: 16.0),
                  ),
          ),
        ],
      ),
    );
  }
}
