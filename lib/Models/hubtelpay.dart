import 'dart:convert';
// import 'package:ssh2/ssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
class hubtelpay extends StatefulWidget {
  const hubtelpay({super.key});

  @override
  State<hubtelpay> createState() => _hubtelpayState();
}



final TextEditingController _recipientNameController = TextEditingController();
final TextEditingController _recipientMsisdnController = TextEditingController();
final TextEditingController _customerEmailController = TextEditingController();
final TextEditingController _channelController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
final TextEditingController _primaryCallbackController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _clientReferenceController = TextEditingController();
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
              controller: _clientReferenceController,
              decoration: InputDecoration(labelText: 'Reference'),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _executeScript,
            //   child: Text('Send Direct Payment'),
            // ),
          ],
        ),
      ),
    );
  }

}

// void _executeScript() async {
//   SSHClient client = SSHClient(
//     host: '35.208.43.102', // Replace with your GCP VM's static IP
//     port: 22, // Default SSH port
//     username: 'filldprojectwideuser',
//     passwordOrKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChwTWL3hHmEMgNkx2R0lJyej2ADb37HFOzKEg9FmylStC3owePQzDV+CY5DTdxhVuBIpUz6K32zD+xZpVWD8U7niXu0iuIbo0QuJoI8eRP5JYo7R82R2aswPB480OYouI0X22/08pc1c/x7lKCk1pUxYAE/qHRD2XcwFa4EyvjLu27/GGPVWIo+d9Gq6MQ4nkN41Z4PvxjcQfEBZH3lPiu27p6TpXe3lfEhhvlvETjb3KrP9o5X/cFBnf07bKoYyQq/bHSxxUWUwLFl+INXJSNmvVKyImW7V5l6WCwd8LZC6M7K8Zu6bTIMBSeLzBAEP84UgCCGdu8P97BHW+zjsqLpll8gmz+WY7qPfmuUCG+VCZengWd2zdhdWfvEYrdGvfzf6qMGglIj0hHeIF1vPSWxN1QlC/Eb7OSxokI+oCZSMxtttrDoodVNTtbPrkOjQlGiC5Ql3374vGFIckw4YUHUFtLZbpznxk5QuwoaJtdt6N1tdu2C7e3WVQdCWPjjq/ZE6IrCPufAuMeat6vhXCOrrGYXfcPXDSO5peekdVzFJeZU4MrlsQjP0bcBXZHhww19Zj/BoS9fChSdVbv9KbXK/5Jtw0gGqtnUFSipR0NjjdxqP/fVW6wpfk85/cPcAwDq8r42soivMVkER1vL0roMpYx9peyZ9psYruNOg15gQ== filldprojectwideuser'
//     // passwordOrKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO52OhhtiKwMCOI2ok6E+vljKnea+TH9HtlqKDLJNw+GFiJaE5WlvnjLpebg/maasf6Op05fsKsY9TH0YUv3ksTg0j8YPdCpcguHCv1gXfZU77gBhVF0KNylr4fcKyl5tmYCp5ZTIv31NSTF+e3+enZDRrZsGmnpT63wWVQQFTBl23t+BpUHghoFaL+A6vpEeyP0rCe+EdtO1+4xQhk2t4B3Q0/wqV82DLDB4QJc2wC0N3uCILIz69qKNQL9qxVdRXoiyYE6Bw2DzVRYK0h+/3CdM8yC4fVLjD98b8h3WEDywdVy+JXGAfa4fkb5zrggQQXO1Eu+HV7i/ojaQcXIUr merchantdaniel8@filld.us-central1-a.c.artisan-5c916.internal',
//   );
//
//   try {
//     // Attempt SSH connection
//     String? result = await client.connect();
//     print('Connection result: $result');
//
//     // Command to execute the script with parameters
//     String command = 'bash /hubtel_request.sh '
//         '${_recipientNameController.text} '
//         '${_recipientMsisdnController.text} '
//         '${_amountController.text} '
//         '${_channelController.text} '
//         '${_clientReferenceController.text} '
//     // Add other parameters here
//         .trim();
//
//     // Execute the command
//     String? output = await client.execute(command);
//     print('Command output: $output');
//
//     // Disconnect SSH client
//     client.disconnect();
//   } catch (e) {
//     // Error handling
//     print('Error occurred: $e');
//     // Add more specific error handling and logging if needed
//   }
// }


//
// void _executeScript() async {
//   SSHClient client = SSHClient(
//     host: '35.208.43.102', // Replace with your GCP VM's static IP
//     port: 22, // Default SSH port
//     username: 'merchantdaniel8',
//     passwordOrKey:'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO52OhhtiKwMCOI2ok6E+vljKnea+TH9HtlqKDLJNw+GFiJaE5WlvnjLpebg/maasf6Op05fsKsY9TH0YUv3ksTg0j8YPdCpcguHCv1gXfZU77gBhVF0KNylr4fcKyl5tmYCp5ZTIv31NSTF+e3+enZDRrZsGmnpT63wWVQQFTBl23t+BpUHghoFaL+A6vpEeyP0rCe+EdtO1+4xQhk2t4B3Q0/wqV82DLDB4QJc2wC0N3uCILIz69qKNQL9qxVdRXoiyYE6Bw2DzVRYK0h+/3CdM8yC4fVLjD98b8h3WEDywdVy+JXGAfa4fkb5zrggQQXO1Eu+HV7i/ojaQcXIUr merchantdaniel8@filld.us-central1-a.c.artisan-5c916.internal',
//   );
//
//   try {
//     String? result = await client.connect();
//     print('ddf:$result');
//
//     // Command to execute the script with parameters
//     String command = 'bash /hubtel_request.sh '
//         '${_recipientNameController.text} '
//         '${_recipientMsisdnController.text} '
//         '${_amountController.text} '
//         '${_channelController.text} '
//         '${_clientReferenceController.text} '
//     // Add other parameters here
//         .trim();
//
//     String? output = await client.execute(command);
//     print(output);
//
//     client.disconnect();
//   } catch (e) {
//     print('Error: $e');
//   }
// }
