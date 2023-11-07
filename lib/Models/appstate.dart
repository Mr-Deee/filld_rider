import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:filld_rider/pages/homepage.dart';


class AppState with ChangeNotifier {
  // Existing properties
  Color driverStatusColor = Colors.white70;
  String driverStatusText = "Offline";
  bool isDriverAvailable = false;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.4219999, -122.0840575), // Replace with your desired initial location
    zoom: 14.4746,
  );
  GoogleMapController? controller;
  bool myLocationButtonEnabled = true;
  // CameraPosition initialCameraPosition = homepage._kGooglePlex;
  bool myLocationEnabled = true;

  void updateDriverStatus(Color color, String text, bool availability) {
    driverStatusColor = color;
    driverStatusText = text;
    isDriverAvailable = availability;
    notifyListeners();
  }

  void setController(GoogleMapController newController) {
    controller = newController;
    notifyListeners();
  }

  void updateMyLocationButtonEnabled(bool enabled) {
    myLocationButtonEnabled = enabled;
    notifyListeners();
  }

  void updateMyLocationEnabled(bool enabled) {
    myLocationEnabled = enabled;
    notifyListeners();
  }
}

// Other methods and properties
