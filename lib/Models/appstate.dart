import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  // Existing properties
  Color driverStatusColor = Colors.white70;
  String driverStatusText = "Offline";
  bool isDriverAvailable = false;

  void updateDriverStatus(Color color, String text, bool availability) {
    driverStatusColor = color;
    driverStatusText = text;
    isDriverAvailable = availability;
    notifyListeners();
  }

// Other methods and properties
}