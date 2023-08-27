
import 'package:filld_rider/pages/Authpage.dart';
import 'package:filld_rider/pages/riderdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'homepage.dart';
class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;

  OtpVerificationScreen({required this.verificationId});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState(verificationId);
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  final String verificationId;

  _OtpVerificationScreenState(this.verificationId);
  void verifyCode(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    String pin = _pinController1.text +
        _pinController2.text +
        _pinController3.text +
        _pinController4.text;
    try {
      // Create a PhoneAuthCredential with the verification code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: pin.trim(),
      );

      // Sign in with the credential
      await _firebaseAuth.signInWithCredential(credential);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Riderdetails()),
              (Route<dynamic> route) => false);
      // // Now you can continue with user registration
      // Ne the code entry screen
      // registerNewUser(context);
    } catch (e) {
      // Handle any errors that occur during code verification.
      displayToast("Verification failed: $e", context);
    }
  }

  TextEditingController _pinController1 = TextEditingController();
  TextEditingController _pinController2 = TextEditingController();
  TextEditingController _pinController3 = TextEditingController();
  TextEditingController _pinController4 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Verification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Verification Code"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildPinTextField(_pinController1),
                SizedBox(width: 16.0),
                buildPinTextField(_pinController2),
                SizedBox(width: 16.0),
                buildPinTextField(_pinController3),
                SizedBox(width: 16.0),
                buildPinTextField(_pinController4),
              ],
            ),
            ElevatedButton(
              onPressed: () => verifyCode(context),
              child: Text("Verify Code"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPinTextField(TextEditingController controller) {
    return Container(
      width: 50.0,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        obscureText: true,
        decoration: InputDecoration(
          counter: Offstage(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

