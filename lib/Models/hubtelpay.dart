import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class hubtelpay extends StatefulWidget {
  const hubtelpay({super.key});

  @override
  State<hubtelpay> createState() => _hubtelpayState();
}

Future<void> initiatePayment2() async {
  // final String url = 'https://payproxyapi.hubtel.com/items/initiate';
  // final String clientId = 'NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw==';
  final String ?clientReference = "REF_${DateTime.now().millisecondsSinceEpoch}";
  print("1:");
  // final Map<String, dynamic> requestData = {
  //
  // };

  try {
    print("2");

   var   headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw=='
    };


      var request = http.Request('POST',
          Uri.parse('https://smp.hubtel.com/api/merchants/2018643/send/mobilemoney'));
    request.body = json.encode({
      "RecipientName": "Daniel",
      "RecipientMsisdn": "233596423095",
      "CustomerEmail": "merchantdaniel8@gmail.com",
      "Channel": "mtn-gh",
      "Amount": 0.1,
      "PrimaryCallbackUrl": "https://webhook.site/66252c48b-aa29-a8f0182d01ab",
      "Description": "Withdrawal",
      "ClientReference": "pay132"
    });
    print("3");
    request.headers.addAll(headers);
    print("Payment URL: ");
    http.StreamedResponse response = await request.send();
    print("Payment URL: $response");
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      try {
        String paymentUrl = await response.stream.bytesToString();
        final Uri paymentUri = Uri.parse(paymentUrl);


        if (paymentUrl!=null) {
          // For mobile platforms, you can use the launch function from the 'url_launcher' package
          await launchUrl(paymentUri);
          print("Payment URL: $paymentUrl");
        } else {
          // For other platforms, you can print the URL for the user to open manually
          print("Payment URL: $paymentUrl");
        }
      } catch (e) {
        // Handle network or other errors
        print("Error: $e");
      }
    }
  }catch (e) {
    // Handle network or other errors
    print("Error: $e");
  }
}
class _hubtelpayState extends State<hubtelpay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hubtel Payment "),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            initiatePayment2();
          },
          child: Text("Make Payment"),

        ),
      ),
    );
  }
}
