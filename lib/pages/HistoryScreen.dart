import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:filld_rider/DataHandler/appData.dart';
import 'package:filld_rider/HistoryItem.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';





class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}



class _HistoryScreenState extends State<HistoryScreen> {
 String? facts ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: Text('Job History',style: TextStyle(color: Colors.white),),
        backgroundColor:Colors.black,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),

        ),actions: [ ElevatedButton(
          onPressed: () {
    fetchFacts();
    },
      child: Text('Get Random Fact'),
    ),
    ],
      ),

      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index)
        {

          final historyItem= Provider.of<AppData>(context, listen: false).tripHistoryDataList[index];

          return HistoryItem(
            clienthistory: Provider.of<AppData>(context, listen: false).tripHistoryDataList[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 3.0, height: 3.0,),
        itemCount: Provider.of<AppData>(context, listen: false).tripHistoryDataList.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
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
        _showFactDialog();
      } else {
        throw Exception('Failed to load facts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  void _showFactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Random Fact'),
          content: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "$facts" ,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
