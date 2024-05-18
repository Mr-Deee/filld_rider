import 'package:filld_rider/pages/riderdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import '../Models/Assistants/assistantmethods.dart';
import '../main.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'Onetimepassword.dart';
import 'forgetpassword.dart';
import 'homepage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'mainscreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;
  Position? currentPosition;

  void initState() {
    // TODO: implement initState
    super.initState();
    locatePosition(context);
    // requestSmsPermission();
    _requestLocationPermission();
    AssistantMethod.getCurrentOnlineUserInfo(context);
    _getCurrentLocation();
  }

  GoogleMapController? newGoogleMapController;
  bool _obscureText = true;

  TextEditingController _locationController = TextEditingController();

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      List<Placemark> placemarks = await GeocodingPlatform.instance
      !.placemarkFromCoordinates(position.latitude, position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String placeName = placemark.name ?? ''; // Name of the place
        String locality = placemark.locality ?? ''; // City or locality
        String administrativeArea =
            placemark.administrativeArea ?? ''; // State or region

        String fullAddress = '$placeName, $locality, $administrativeArea';

        setState(() {
          currentPosition = position;
          _locationController.text = fullAddress;
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      _getCurrentLocation();
    }
  }

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

  void locatePosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLatPosition, zoom: 20);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address =
    // await AssistantMethod.searchCoordinateAddress(position, context);
    // print("This is your Address::" + address);
    // initGeoFireListener();

  }


  void _toggleForm(bool isSignIn) {
    setState(() {
      _isSignIn = isSignIn;
    });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signin() async {
    final emailController = TextEditingController();

    // text editing controllers
    final passwordController = TextEditingController();
    try {
      // Step 1: Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Step 2: Save a flag to indicate that the user is logged in using shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pop(
            context); // Go back to the previous page (assuming this is a modal dialog).
      } else {
        print('Invalid credentials.');
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2E9E9),
      //Color(0xff23252A),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 280,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            children: [IconButton(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              tooltip: 'Go back',
                              enableFeedback: true,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pushNamed("/authpage");
                              },
                            ),
                            ],
                          ),
                          Container(
                            // autogroup5cgo8Cw (LrGFcrPtMqbkTfkxCG5cgo)
                            padding: EdgeInsets.fromLTRB(15, 150, 23, 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/delivery-with-white-background-1.png',
                                ),
                              ),
                            ),),
                          //
                          // Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // _isSignIn ? SignInForm() : SignUpForm(),
                                  SizedBox(height: 1.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      AuthOptionButton(
                                        text: 'Login',
                                        isSelected: _isSignIn,
                                        onTap: () => _toggleForm(true),
                                      ),
                                      SizedBox(width: 20.0),
                                      AuthOptionButton(
                                        text: 'Sign Up',
                                        isSelected: !_isSignIn,
                                        onTap: () => _toggleForm(false),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0),
                  _isSignIn ? SignInForm() : SignUpForm(),

                ],
              ),
            )),
      ),
    );
  }


}

displayToast(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

class AuthOptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AuthOptionButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, left: 35, right: 35, bottom: 30),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 40.0),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,

                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: _obscureText ? Colors.grey : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });

                        }),
                  ),)),


            SizedBox(height: 15.0),
            Row(
              children: [
                GestureDetector(
                  onTap:(){   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                  );} ,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),


            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                loginAndAuthenticateUser(context);
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6.0,
                            ),
                            CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            SizedBox(
                              width: 26.0,
                            ),
                            Text("Loging In,please wait")
                          ],
                        ),
                      ))));
        });

    final User? firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
      email: _emailController.text.toString().trim(),
      password: _passwordController.text.toString().trim(),
    )
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Error" + errMsg.toString(), context);
    }))
        .user;
    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      // const String adminEmail = 'admin@gmail.com';
      // if(emailController.text==adminEmail){
      //
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => admin()));
      //
      // }
      // else
      if (firebaseUser != null) {
        AssistantMethod.getCurrentOnlineUserInfo(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false);
        displayToast("Logged-in ", context);
      } else {
        displayToast("Error: Cannot be signed in", context);
      }
    } catch (e) {
      // handle error
    }
  }
}

final emailController = TextEditingController();
final firstnameController = TextEditingController();
final lastnameController = TextEditingController();
final passwordeController = TextEditingController();
final phonecontroller = TextEditingController();
String _verificationId = "";
final passwordController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;


class SignUpForm extends StatefulWidget {

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locatePosition();
    // requestSmsPermission();
    _getCurrentLocation();

    _requestLocationPermission();
  }

  String selectedCountryCode = '+233'; // Default country code


  String verificationId = '';
  GoogleMapController? newGoogleMapController;
  Position? currentPosition;

  final Random random = Random();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      List<Placemark> placemarks = await GeocodingPlatform.instance
      !.placemarkFromCoordinates(position.latitude, position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String placeName = placemark.name ?? ''; // Name of the place
        String locality = placemark.locality ?? ''; // City or locality
        String administrativeArea =
            placemark.administrativeArea ?? ''; // State or region

        String fullAddress = '$placeName, $locality, $administrativeArea';

        setState(() {
          // _currentPosition = position;
          // _locationController.text = fullAddress;
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

  //Request permission On signup
  void requestSmsPermission() async {
    if (await Permission.sms
        .request()
        .isGranted) {
      // You have the SEND_SMS permission.
    } else {
      // You don't have the SEND_SMS permission. Show a rationale and request the permission.
      if (await Permission.sms
          .request()
          .isPermanentlyDenied) {
        // The user has permanently denied the permission.
        // You may want to navigate them to the app settings.
        openAppSettings();
      } else {
        // The user has denied the permission but not permanently.
        // You can request the permission again.
        requestSmsPermission();
      }
    }
  }

  bool _obscureText = true;

//SendVerififcation
  void sendVerificationCode() {
    final int verificationCode = random.nextInt(900000) + 100000;
    final String message = 'Your verification code is: $verificationCode';

    // sendMS(message);
    registerNewUser(context);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: firstnameController,
            decoration: InputDecoration(labelText: 'First name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: lastnameController,
            decoration: InputDecoration(labelText: 'Last name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
        ),

        Row(

          children: [
            CountryCodePicker(
              onChanged: (CountryCode code) {
                setState(() {
                  selectedCountryCode = code.dialCode!;
                });
              },
              initialSelection: 'GH',
              // Initial country
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              favorite: ['+233', 'GH'],
            ),
            Container(
              width: 200.0, // Adjust to the desired width

              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextFormField(
                  controller: phonecontroller,
                  decoration: InputDecoration(labelText: 'Phone number'),
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: passwordController,
              obscureText: _obscureText,

              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _obscureText ? Colors.grey : Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });

                    }),
              ),)),
        ElevatedButton(
          onPressed: () {
            _verifyPhoneNumber();
            registerNewUser(context);


            // _verifyPhoneNumber();

          },
          child: Text('Sign Up'),
        ),
      ],
    );
  }

  String? _verificationCode;
  User? firebaseUser;
  User? currentfirebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _verifyPhoneNumber() async {
    String phone = '$selectedCountryCode${phonecontroller.text}';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> registerNewUser(BuildContext context) async {
    String fullPhoneNumber = '$selectedCountryCode${phonecontroller.text.trim()
        .toString()}';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 6.0,),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black),),
                            SizedBox(width: 26.0,),
                            Text("Signing up,please wait...")

                          ],
                        ),
                      ))));
        });


    firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Error" + errMsg.toString(), context);
    }))
        .user;


    if (firebaseUser != null) // user created

        {
      //save use into to database

      Map userDataMap = {

        "email": emailController.text.trim().toString(),
        "FirstName": firstnameController.text.trim().toString(),
        "LastName": lastnameController.text.trim().toString(),
        "phoneNumber": fullPhoneNumber,
        "Password": passwordController.text.trim().toString(),

      };
      Ridersdb.child(firebaseUser!.uid).set(userDataMap);
      // Admin.child(firebaseUser!.uid).set(userDataMap);

      currentfirebaseUser = firebaseUser;
      // registerInfirestore(context);

      // sendVerificationCode();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         OtpVerificationScreen(verificationId: verificationId),
      //   ),
      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Riderdetails(),
        ),
      );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return login();
      //   }),
      // );      // Navigator.pop(context);
      // error occured - display error
      displayToast("user has not been created", context);
    }
  }

  Future<void> registerInfirestore(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance.collection('Clients').doc(user?.uid).set({
        'FirstName': firstnameController.text.toString().trim(),
        'MobileNumber': phonecontroller.toString().trim(),
        // 'fullName':_firstName! +  _lastname!,
        'Email': emailController.text.toString().trim(),
        'Password': passwordController.text.toString().trim(),
        'Phone': phonecontroller.text.toString().trim(),
        // 'Gender': Gender,
        // 'Date Of Birth': birthDate,
      });
    } else
      print("ahh shit");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return SignInScreen();
    //   }),
    // );
  }
}
