import 'package:firebase_database/firebase_database.dart';

class History
{
  String? paymentMethod;
  String ?createdAt;
  String ?status;
  String ?fares;
  String ?dropOff;
  String ?pickup;

  History({this.paymentMethod, this.createdAt, this.status, this.fares, this.dropOff, this.pickup});

  History.fromSnapshot(DataSnapshot dataSnapshot) {

    final data = Map<String, dynamic>.from((dataSnapshot).value as Map);

// return History(


    paymentMethod =data["payment_method"];
    createdAt= data["created_at"];
    status =data["status"];
    fares =data["fares"];
    dropOff=data["dropoff_address"];
    pickup = data["pickup_address"];

  }
}