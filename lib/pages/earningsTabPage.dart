//import 'package:driver_app/AllScreens/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../DataHandler/appData.dart';
import 'HistoryScreen.dart';

class EarningsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black87,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                   Image(image: AssetImage("assets/images/Moto.png")),
                    Text(
                      'Total Earnings',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "\ GH¢${Provider.of<AppData>(context, listen: true).earnings}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Brand Bold'),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              // padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                child: Row(
                  children: [
                    // Image.asset(
                    //   'images/RevExecutive.png',
                    //   width: 70,
                    // ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Total Delievries',
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                        child: Container(
                            child: Text(
                      Provider.of<AppData>(context, listen: false)
                          .countTrips
                          .toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                    ))),



                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
              width: 16,
            ),
            Divider(
              height: 2.0,
              thickness: 3.0,
              color: Colors.blueGrey,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "All riders get paid all their earnings 8 pm each day into a momo account.Fill'd takes 15% of each delivery fee.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
