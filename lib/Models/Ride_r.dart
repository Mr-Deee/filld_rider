import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

class Ride_r extends ChangeNotifier
{
  String?firstname;
  String?lastname;
  String?phone;
  String?email;
  String?id;
  String?automobile_color;
  String? automobile_model;
  String?plate_number;
  String?profilepicture;

  Ride_r({this.firstname, this.lastname,this.phone, this.email, this.id, this.automobile_color, this.automobile_model, this.plate_number, this.profilepicture,});

  static Ride_r fromMap(Map<String, dynamic> data)

  {
    // Map<String, dynamic> data = snapshot.value;
    //var data= dataSnapshot.value;
    return Ride_r(
      id: data['id'],
      phone: data["phoneNumber"],
      email: data["email"],
      firstname: data["FirstName"],
      lastname: data["LastName"],
      profilepicture: data["riderImageUrl"],
    automobile_color: data["car_details"]["automobile_color"],
    automobile_model: data["car_details"]["motorBrand"],
     plate_number:data["car_details"]["licensePlateNumber"],
    );
  }

  Ride_r? _riderInfo;

  Ride_r? get riderInfo => _riderInfo;

  void setRider(Ride_r rider) {
    _riderInfo = rider;
    notifyListeners();
  }
}
