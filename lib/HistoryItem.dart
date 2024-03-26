import 'package:flutter/material.dart';
import 'package:filld_rider/Models/history.dart';
import '../Models/Assistants/assistantmethods.dart';

class HistoryItem extends StatelessWidget {
  final History clientHistory;

  HistoryItem({required this.clientHistory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Image.asset(
                'assets/images/pickup.png',
                height: 16,
                width: 16,
              ),
              SizedBox(width: 18),
              Expanded(
                child: Container(
                  child: Text(
                    clientHistory.pickup!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(width: 5),
              // Text('\ GH¢${history!.fares}', style: TextStyle(fontFamily: 'Brand Bold', fontSize: 16, color: Colors.black87),),
            ],
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/location.png',
                  height: 16,
                  width: 16,
                ),
                SizedBox(width: 18),
                Text(
                  clientHistory.dropOff!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(
            AssistantMethod.formatTripDate(clientHistory.createdAt!),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
