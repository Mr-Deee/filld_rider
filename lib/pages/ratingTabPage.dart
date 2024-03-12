// import 'package:driver_app/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../configMaps.dart';

class RatingTabPage extends StatefulWidget {
  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rate Review",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,),
      backgroundColor: Colors.white60,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22.0,
              ),
              Text(
                "Your Review",
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand Bold",
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 22.0,
              ),
              Divider(
                height: 2.0,
                thickness: 2.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              SmoothStarRating(
                rating: starCounter,
                color: Colors.green,
                allowHalfRating: true,
                starCount: 5,
                size: 45,
                // isReadOnly: true,
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: "Signatra",
                    color: Colors.black),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
