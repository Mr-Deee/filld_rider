
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/Assistants/assistantmethods.dart';

class CollectFareDialog extends StatefulWidget {
  final String? paymentMethod;
  final int? fareAmount;

  CollectFareDialog({this.paymentMethod, this.fareAmount});
  @override
  State<CollectFareDialog> createState() => _CollectFareDialogState(paymentMethod: paymentMethod,fareAmount: fareAmount);
}

class _CollectFareDialogState extends State<CollectFareDialog> {
  String ?paymentMethod;

  String? facts ="";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFacts();
  }
  int ?fareAmount;
  _CollectFareDialogState({ this.paymentMethod,  this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0,),

         Text("Fun Facts",  style: TextStyle(fontSize: 16.0,
             fontWeight: FontWeight.bold,
             fontFamily: "Brand Bold"),),

            SizedBox(height: 22.0,),

            Divider(thickness: 4.0,),

            SizedBox(height: 16.0,),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("$facts"??"Your Fun Fact Will be here shortly..", textAlign: TextAlign.center,),
            ),

            SizedBox(height: 30.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side:
                      const BorderSide(color: Colors.white)),
                ),

                onPressed: () async
                {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  AssistantMethod.enableHomeTabLiveLocationUpdates();
                },
                //color: Colors.deepPurpleAccent,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Done", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.0,),
          ],
        ),
      ),
    );
  }

  Future<void> fetchFacts() async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/facts?limit=1');
    final headers = {'X-Api-Key': 'C6I2OTzM2wctRCE6KKi8sQ==SYJVNnpVrCDaY5rE'};

    final response = await http.get(url, headers: headers);

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('jsonData: $jsonData');
        final data  = jsonData[0]['fact'] ;

        print('Type of data: ${data.runtimeType}');
        print('Value of data: $data');

        setState(() {
          facts = data;
        });
        // _showFactDialog();
      } else {
        throw Exception('Failed to load facts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
