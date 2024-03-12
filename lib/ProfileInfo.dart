import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../configMaps.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key, this.leading, this.subtitle, this.title})
      : super(key: key);
  final IconData? leading; // Changed type to IconData  final String ?title;

  final String ?title;
  final String ?subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.0,
        ),
        Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 18.0),
                child: Icon(
                  leading, // Use IconData directly
                  size: 27.0, // Adjust size as needed
                  color: Colors.black, // Adjust color as needed
                ),
              ),
              SizedBox(
                width: 30.0,
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title??"",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    subtitle??"",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
}
