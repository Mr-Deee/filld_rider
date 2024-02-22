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

// Future<void> initiatePayment2() async {
//   // final String url = 'https://payproxyapi.hubtel.com/items/initiate';
//   // final String clientId = 'NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw==';
//   final String ?clientReference = "REF_${DateTime.now().millisecondsSinceEpoch}";
//   print("1:");
//   // final Map<String, dynamic> requestData = {
//   //
//   // };
//
//   try {
//     print("2");
//
//    var   headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Basic NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw=='
//      'Host:10.128.0.3'
//     };
//
//
//       var request = http.Request('POST',
//           Uri.parse('https://smp.hubtel.com/api/merchants/2018643/send/mobilemoney'));
//     request.body = json.encode({
//       "RecipientName": "Daniel",
//       "RecipientMsisdn": "233596423095",
//       "CustomerEmail": "merchantdaniel8@gmail.com",
//       "Channel": "mtn-gh",
//       "Amount": 0.1,
//       "PrimaryCallbackUrl": "https://webhook.site/66252c48b-aa29-a8f0182d01ab",
//       "Description": "Withdrawal",
//       "ClientReference": "pay132"
//     });
//     print("3");
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     print("Payment URL1: $request");
//     if (response.statusCode == 200) {
//       String dasd= await response.stream.bytesToString();
//       print("dash:${dasd}");
//       print("Payment URL2: $request");
//       try {
//         String paymentUrl = await response.stream.bytesToString();
//         final Uri paymentUri = Uri.parse(paymentUrl);
//
//
//         if (paymentUrl!=null) {
//           // For mobile platforms, you can use the launch function from the 'url_launcher' package
//           await launchUrl(paymentUri);
//           print("Payment URL1: $paymentUri");
//         } else {
//           // For other platforms, you can print the URL for the user to open manually
//           print("Payment URL1: $paymentUri");
//         }
//       } catch (e) {
//         // Handle network or other errors
//         print("Error: $e");
//       }
//     }
//   }catch (e) {
//     // Handle network or other errors
//     print("Error: $e");
//   }
// }

final TextEditingController _recipientNameController = TextEditingController();
final TextEditingController _recipientMsisdnController = TextEditingController();
final TextEditingController _customerEmailController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
class _hubtelpayState extends State<hubtelpay> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _recipientNameController,
              decoration: InputDecoration(labelText: 'Recipient Name'),
            ),
            TextField(
              controller: _recipientMsisdnController,
              decoration: InputDecoration(labelText: 'Recipient MSISDN'),
            ),
            TextField(
              controller: _customerEmailController,
              decoration: InputDecoration(labelText: 'Customer Email'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: executeScript,
              child: Text('Send Direct Payment'),
            ),
          ],
        ),
      ),
    );
  }

}


Future<void> _sendDirectPayment() async {
  final String apiUrl = 'https://smp.hubtel.com/api/merchants/2018643/send/mobilemoney';

  // Replace 'YOUR_API_KEY' with your actual Hubtel API key
  final String apiKey = 'YOUR_API_KEY';

  final Map<String, dynamic> requestData = {
    'RecipientName': "Daniel",
    'RecipientMsisdn': "233503926630",
    'CustomerEmail': "merchantdaniel8@gmail.com",
    'Channel': 'vodafone-gh',
    'Amount': 0.2,
    'PrimaryCallbackUrl': 'https://webhook.site/b503d1a9-e726-f315254a6ede',
    'Description': "_descriptionController.tex",
    'ClientReference': 'pay101'
  };

  final response = await http.post(
    Uri.parse('https://smp.hubtel.com/api/merchants/2018643/send/mobilemoney'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic NzNsckFnTzo5ODlmNmEzYzUxNWE0MGJkOTc2ZTIyMDllZjAzZTU2Yw==',
      'Host': 'https://smp.hubtel.com', // Corrected the host
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    // Payment request successful
    // You can handle success response here
    print('Direct payment request successful');
  } else {
    // Payment request failed
    // You can handle error response here
    print('Direct payment request failed with status code: ${response.statusCode}');
  }
}
Future<void> executeScript() async {
  final apiUrl = 'https://us-central1-artisan-5c916.cloudfunctions.net/hubtelpay';
      //'http://35.208.43.102:8080/executescript'; // Update with your VM IP address
  final Map<String, dynamic> requestData = {
    'RecipientName': "_recipientNameController.text",
    'recipientMsisdn': "233503026630",
     'CustomerEmail': "merchantdaniel8@gmail.com",
     'Channel': 'vodafone-gh',
      'Amount':0.2,
     'PrimaryCallbackUrl': 'https://webhook.site/b503d1a9-e726-f315254a6ede',
     'Description': "dd",
      'ClientReference': 'pay101'
    // Include other dynamic values as needed
  };
  print('Script executed successfully1');
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );
    print('Script executed successfully2');
    if (response.statusCode == 200) {
      print('Script executed successfully');
    } else {
      print('Failed to execute script. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error executing script: $e');
  }
}
