import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../main.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'Onetimepassword.dart';
import 'homepage.dart';
class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;

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
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all( Radius.circular(40)),
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
                            ),],
                          ),
          Container(
              // autogroup5cgo8Cw (LrGFcrPtMqbkTfkxCG5cgo)
              padding: EdgeInsets.fromLTRB(15, 150, 23, 8),
              width: double.infinity,
              decoration: BoxDecoration (
                image: DecorationImage (
                  fit: BoxFit.cover,
                  image: AssetImage (
                      'assets/images/delivery-with-white-background-1.png',
                  ),
                ),
              ),),
                          //
                          // Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top:1.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // _isSignIn ? SignInForm() : SignUpForm(),
                                  SizedBox(height: 1.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class SignInForm extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 35,right: 35,bottom: 30),
      child: Column(
        children: [
          SizedBox(height: 30.0),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'E-mail'),
          ),
          SizedBox(height: 40.0),
          TextField(
          controller:   _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text('Forgot password?',style: TextStyle(color: Colors.blueAccent),),
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => homepage()),
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


  String selectedCountryCode = '+1'; // Default country code

  String phoneNumber = '';
  String verificationId = '';


  Future<void> _verifyPhoneNumber() async {


    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Verification failed: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) async {
      // Save the verification ID so that you can use it later
      this.verificationId = verificationId;
      // Navigate to the OTP verification screen or show UI to enter OTP.
      // You can use Navigator to move to the next screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(verificationId: verificationId, ),
        ),
      );

    };


    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phonecontroller.text,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );



    // final PhoneCodeSent codeSent
    registerNewUser(context);
               // registerInfirestore(context);
    displayToast("Congratulation, your account has been created", context);


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
        )    ,
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
              initialSelection: 'US', // Initial country
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              favorite: ['+1', 'US'],
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
          child: TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtpVerificationScreen(verificationId: verificationId),
              ),
            );
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

  Future<void> registerNewUser(BuildContext context) async {
    String fullPhoneNumber = '$selectedCountryCode$phoneNumber';
    try {

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
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                            SizedBox(width: 26.0,),
                            Text("Verifying Your Number...")

                          ],
                        ),
                      ))));
        });


    // Start phone number verification
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber.trim(), // The user's phone number
      timeout: const Duration(seconds: 60), // Timeout duration
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval of the verification code succeeded.
        // This callback will be called when the code is automatically
        // retrieved from the SMS (if auto-retrieval is enabled).
        // You can proceed with registration here if needed.
      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed due to an error.
        // Handle the error, e.g., display an error message to the user.
        Navigator.pop(context); // Close the loading dialog
        displayToast("Verification failed: ${e.message}", context);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Verification code has been successfully sent to the user's phone.
        // Store the verification ID and show a screen to enter the code.
        // You can navigate to a new screen to allow the user to enter the code
        // and complete the registration process.
        Navigator.pop(context); // Close the loading dialog
        // Navigate to the code verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval of the verification code timed out.
        // Handle the timeout, e.g., ask the user to manually enter the code.
        Navigator.pop(context); // Close the loading dialog
        displayToast("Verification code expired. Please try again.", context);
      },

    );
  } catch (e) {
  // Handle any other exceptions that may occur during phone number verification.
  Navigator.pop(context); // Close the loading dialog
  displayToast("Error: $e", context);
  }

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
      clientdb.child(firebaseUser!.uid).set(userDataMap);
      // Admin.child(firebaseUser!.uid).set(userDataMap);

      currentfirebaseUser = firebaseUser;
      // registerInfirestore(context);


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
        'FirstName':firstnameController.text.toString().trim(),
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