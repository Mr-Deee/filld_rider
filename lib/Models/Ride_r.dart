import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Ride_r extends ChangeNotifier
{
  String ?firstname;
  String ?lastname;
  String ?phone;
  String ?email;
  String ?id;
  String ?servicetype;
  String ?education;
  String ?plate_number;
  String ?profilepicture;

  Ride_r({this.firstname, this.lastname,this.phone, this.email, this.id, this.servicetype, this.education, this.plate_number, this.profilepicture,});

  Ride_r.fromSnapshot(DataSnapshot dataSnapshot) {
    final data = Map<String, dynamic>.from((dataSnapshot).value as Map);


      id= data['uid'];
      phone= data["phoneNumber"];
      email= data["email"];
      firstname= data["FirstName"];
    lastname= data["LastName"];
     // profilepicture= data["profilepicture"].toString();
    servicetype= data["Service Type"];
    education= data["Education Background"];

     // plate_number=data["car_details"]["plate_number"];

  }
}
