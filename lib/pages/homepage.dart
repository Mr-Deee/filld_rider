import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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


  getartisanType() {
    artisansRef
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
  //
  // getRatings() {
  //   //update ratings
  //
  //   artisansRef
  //       .child(currentfirebaseUser!.uid)
  //       .child("ratings")
  //       .once()
  //       .then((value) {
  //     var dataSnapshot = value.snapshot;
  //     final map = dataSnapshot.value;
  //
  //     if (dataSnapshot != null) {
  //       double ratings = double.parse(map.toString());
  //       setState(() {
  //         starCounter = ratings;
  //       });
  //
  //       if (starCounter <= 1.5) {
  //         setState(() {
  //           title = "Very Bad";
  //         });
  //         return;
  //       }
  //       if (starCounter <= 2.5) {
  //         setState(() {
  //           title = "Bad";
  //         });
  //
  //         return;
  //       }
  //       if (starCounter <= 3.5) {
  //         setState(() {
  //           title = "Good";
  //         });
  //
  //         return;
  //       }
  //       if (starCounter <= 4.5) {
  //         setState(() {
  //           title = "Very Good";
  //         });
  //         return;
  //       }
  //       if (starCounter <= 5.0) {
  //         setState(() {
  //           title = "Excellent";
  //         });
  //
  //         return;
  //       }
  //     }
  //   });
  // }

  getCurrentArtisanInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;
    artisans.child(currentfirebaseUser!.uid).once().then((event) {
      print("value");
      if (event.snapshot.value != null) {
        artisanInformation = Arti_san.fromSnapshot(event.snapshot);
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

  Position? _currentPosition;
  String? _currentAddress;
  String ArtisanStatusText = "Go Online ";

  Color ArtisanStatusColor = Colors.white70;
  bool isArtisanAvailable = false;
  bool isArtisanActivated = false;

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
}
