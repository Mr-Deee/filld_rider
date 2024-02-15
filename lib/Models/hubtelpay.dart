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
  final String url = 'https://payproxyapi.hubtel.com/items/initiate';
  final String clientId = 'NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw==';
  final String ?clientReference = "REF_${DateTime.now().millisecondsSinceEpoch}";

  // final Map<String, dynamic> requestData = {
  //
  // };

  try {
    final response = await http.post(
      Uri.parse('https://smp.hubtel.com/api/merchants/{2019342}/send/mobilemoney'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw==',
      },
      body: jsonEncode({
        "RecipientName": "Daniel",
        "RecipientMsisdn":"0503026630",
        "Amount": 0.3,
        "description": "Withdrawal",
        "CustomerEmail": "merchantdaniel8@gmail.com",
        "Channel":"vodafone-gh",
        "callbackUrl": "https://webhook.site/f277-4bbc-b9e2-837f3a930ada",
        "returnUrl": "http://hubtel.com/online",
        "merchantAccountNumber": "2019342",
        "cancellationUrl": "http://hubtel.com/online",
        "clientReference": clientReference ?? "ee",

      }),
    );
    // return json.decode(response.body);
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String paymentUrl = responseData['data']?['checkoutUrl'];
        if (paymentUrl != null) {
          final Uri paymentUri = Uri.parse(paymentUrl);
          // Open the payment URL in a web browser or WebView
          print("Payment URL: $paymentUrl");
          if (paymentUri != null) {
            if (await canLaunchUrl(paymentUri)) {
              await launchUrl(paymentUri);
            } else {
              print("Error launching URL: $paymentUrl");
            }
          }
          else {
            print("Expected keys not found in the response");
          }
        } else {
          // Handle errors
          print("Error: ${response.statusCode}, ${response.body}");
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
