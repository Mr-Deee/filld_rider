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
 bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final tripHistoryDataList = Provider.of<AppData>(context).tripHistoryDataList;
    return Scaffold(


      appBar: AppBar(
        centerTitle: true,
        title: Text('Job History',style: TextStyle(color: Colors.white),),
        backgroundColor:Colors.blue,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),

        ),actions: [

    ],
      ),

      body: _isLoading
          ? CircularProgressIndicator()
          : tripHistoryDataList.isEmpty
          ? Center(child: Text('No trip history available')):
      ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index)
        {

          final historyItem= Provider.of<AppData>(context, listen: false).tripHistoryDataList[index];

          return HistoryItem(
            clientHistory: Provider.of<AppData>(context, listen: false).tripHistoryDataList[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 3.0, height: 3.0,),
        itemCount: Provider.of<AppData>(context, listen: false).tripHistoryDataList.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),

    );
  }




}
