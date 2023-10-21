import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Ride_r extends ChangeNotifier
{
  String ?firstname;
  String ?lastname;
  String ?phone;
  String ?email;
  String ?id;
  String ?automobile_color;
  String ? automobile_model;
  String ?plate_number;
  String ?profilepicture;

  Ride_r({this.firstname, this.lastname,this.phone, this.email, this.id, this.automobile_color, this.automobile_model, this.plate_number, this.profilepicture,});

  Ride_r.fromSnapshot(DataSnapshot dataSnapshot) {
    final data = Map<String, dynamic>.from((dataSnapshot).value as Map);


      id= data['uid'];
      phone= data["phoneNumber"];
      email= data["email"];
      firstname= data["FirstName"];
      lastname= data["LastName"];
      profilepicture= data["profilepicture"].toString();
    automobile_color= data["Service Type"];
    automobile_model= data["motorBrand"];

     // plate_number=data["car_details"]["plate_number"];

  }
}
