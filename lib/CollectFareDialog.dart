
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? funFact = "Your Fun Fact Will be here shortly..";

  Future<void> fetchRandomFunFact() async {
    final CollectionReference funFactsCollection =
    FirebaseFirestore.instance.collection('fun_facts');
    final QuerySnapshot snapshot = await funFactsCollection.get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    final int randomIndex = Random().nextInt(documents.length);
    final DocumentSnapshot randomDoc = documents[randomIndex];
    setState(() {
      funFact = randomDoc['details'];
    });
  }
  String? facts ="";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRandomFunFact();
  }
  int ?fareAmount;
  _CollectFareDialogState({ this.paymentMethod,  this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 22.0,
            ),
            Text(
              "Fun Fact",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 22.0,
            ),
            Divider(
              height: 2.0,
              thickness: 2.0,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20 ),
              child: Text(
                "$funFact",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                // color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                          child: Text(
                            "Done",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      // SvgPicture.asset(
                      //     'assets/images/Vector.svg'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }


}
