
import 'package:filld_rider/pages/sigin.dart';
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

    try {
      // Create a PhoneAuthCredential with the verification code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: codeController.text.trim(),
      );

      // Sign in with the credential
      await _firebaseAuth.signInWithCredential(credential);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => homepage()),
              (Route<dynamic> route) => false);
      // // Now you can continue with user registration
      // Ne the code entry screen
      // registerNewUser(context);
    } catch (e) {
      // Handle any errors that occur during code verification.
      displayToast("Verification failed: $e", context);
    }
  }

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
            ElevatedButton(
              onPressed: () => verifyCode(context),
              child: Text("Verify Code"),
            ),
          ],
        ),
      ),
    );
  }
}

