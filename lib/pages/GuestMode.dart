import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:filld_rider/pages/AboutScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Authpage.dart';

class GuestModeScreen extends StatefulWidget {
  @override
  _GuestModeScreenState createState() => _GuestModeScreenState();
}

class _GuestModeScreenState extends State<GuestModeScreen> {
  final DatabaseReference _gasStationRef =
  FirebaseDatabase.instance.ref().child('GasStation');

  List<Map<String, dynamic>> _gasStations = [];
  Map<dynamic, dynamic>? riderData;
  bool isRiderLoading = true;
  bool riderExists = false;
  void _showCylindersDialog() {
    List<String> cylinderType = ["3kg", "6kg", "7kg", "10kg", "12kg", "14kg"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.local_gas_station, color: Colors.orange),
              SizedBox(width: 10),
              Text("Available Cylinders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cylinderType.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      Icons.local_gas_station,
                      color: Colors.orange.shade700,
                      size: 28,
                    ),
                    title: Text(
                      "${cylinderType[index]} Cylinder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      // Show login prompt when tapping on a cylinder type
                      _showLoginPrompt(cylinderType[index]);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _showLoginPrompt(String cylinder) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Login to Start Delivery"),
        content: Text(
          "Please log in to start delivery for the $cylinder cylinder.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
            ),
            onPressed: () {
              Navigator.pop(context); // Close the prompt
              Navigator.pushNamed(context, '/authpage'); // Navigate to the login page
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }


  void showGasCompanies() {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_gas_station, color: Colors.orange),
              SizedBox(width: 8),
              Text("Gas Companies"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Explore as a Guest...',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                      speed: Duration(milliseconds: 70),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nearby Gas Stations",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 12),

                /// ✅ This is the fix: Constrain your ListView
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _gasStations.length,
                    itemBuilder: (context, index) {
                      final station = _gasStations[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Icon(Icons.local_gas_station,
                              color: Colors.orange, size: 32),
                          title: Text(
                            station['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("📍 ${station['location']}"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Status: ${station['status']}"),
                              Text("📞 ${station['number']}"),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Login Required"),
                                content: Text(
                                  "Please log in to order from ${station['name']}.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade700,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/authpage');
                                    },
                                    child: Text("Login"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.orange)),
            ),
          ],
        );

      },
    );
  }


  @override
  void initState() {
    super.initState();
    _fetchGasStations();
    _fetchRiderData();
  }

  void _fetchGasStations() {
    _gasStationRef.onValue.listen((event) {
      final stationsMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (stationsMap != null) {
        final stationsList = stationsMap.entries.map((entry) {
          final data = Map<String, dynamic>.from(entry.value);
          return {
            'name': data['GasStationName'] ?? 'Unknown',
            'location': data['Location'] ?? '',
            'status': data['GasStatus'] ?? '',
            'number': data['GasStationNumber'] ?? '',
          };
        }).toList();

        setState(() {
          _gasStations = stationsList;
        });
      }
    });
  }

  List<Map<String, dynamic>> riderList = [];

  Future<void> _fetchRiderData() async {
    try {
      final availableRiderSnapshot = await FirebaseDatabase.instance.ref('availableRider').get();

      if (availableRiderSnapshot.exists) {
        final availableRiderData = availableRiderSnapshot.value as Map<dynamic, dynamic>;

        List<Map<String, dynamic>> fetchedRiders = [];

        for (var entry in availableRiderData.entries) {
          final riderKey = entry.key;
          final riderInfo = entry.value as Map<dynamic, dynamic>;

          if (!riderInfo.containsKey('riderId')) {
            print("❌ Missing riderId for availableRider: $riderKey");
            continue;
          }

          final String riderId = riderInfo['riderId'];

          final riderSnapshot =
          await FirebaseDatabase.instance.ref('Rider/$riderId').get();

          if (riderSnapshot.exists) {
            final riderDetails = riderSnapshot.value as Map<dynamic, dynamic>;
            fetchedRiders.add(Map<String, dynamic>.from(riderDetails));
          } else {
            print("⚠️ Rider entry not found for riderId: $riderId");
          }
        }

        setState(() {
          riderList = fetchedRiders;
          isRiderLoading = false;
          riderExists = riderList.isNotEmpty;
        });
      } else {
        setState(() {
          riderExists = false;
          isRiderLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching rider data: $e");
      setState(() {
        isRiderLoading = false;
        riderExists = false;
      });
    }

  }

  Widget _buildRiderInfoCard() {
    if (isRiderLoading) return CircularProgressIndicator();

    if (riderExists && riderData != null) {
      return Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(riderData!['riderImageUrl'] ?? ''),
          ),
          title:
          Text('${riderData!['FirstName']} ${riderData!['LastName']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Phone: ${riderData!['phoneNumber']}"),
              Text("Status: ${riderData!['status']}"),
              Text("Location: ${riderData!['location']}"),
            ],
          ),
        ),
      );
    }

    return SizedBox(); // No rider info to show
  }

  // Method to create the typewriter effect for the description
  Widget _buildTypewriterText(String text) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          speed: Duration(milliseconds: 100),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
      ],
      totalRepeatCount: 19,
      pause: Duration(milliseconds: 500),
      displayFullTextOnTap: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Guest Mode",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Introduction Card with Typewriter Effect and Icon
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.gasPump, // FontAwesome Icon
                      size: 50,
                      color: Colors.orange.shade700,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildTypewriterText(
                        "We connect clients with gas stations and delivery riders for fast and secure gas delivery.",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Header text
            SizedBox(height: 40),
            Text(
              "Explore Our Services",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),

            // 🔥 NEW: Action Cards Row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionCard(
                  title: 'About Us',
                  icon: Icons.info_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  title: 'View Cylinders',
                  icon: Icons.list_alt,
                  onTap: () {
                    _showCylindersDialog();
                  },
                ),
              ],
            ),
            SizedBox(height: 25),

            // 🔥 NEW: Action Cards Row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionCard(
                  title: 'Privacy',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    // Add privacy action if needed
                  },
                ),
                _buildActionCard(
                  title: 'Gas Stations',
                  icon: Icons.location_on,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GasCompaniesPage(gasStations: _gasStations),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionCard(
                  title: 'Delievery Calculator',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    showCalculationDialog(context);
                    // Add privacy action if needed
                  },
                ),     _buildActionCard(
                  title: 'SignUp',
                  icon: Icons.login,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthPage(),
                      ),
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }




}


class GasCompaniesPage extends StatelessWidget {
  final List<Map<String, dynamic>> gasStations;

  const GasCompaniesPage({Key? key, required this.gasStations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.local_gas_station, color: Colors.orange),
            SizedBox(width: 8),
            Text("Gas Companies"),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Explore as a Guest...',
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                  speed: Duration(milliseconds: 70),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nearby Gas Stations",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: gasStations.length,
              itemBuilder: (context, index) {
                final station = gasStations[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.local_gas_station,
                        color: Colors.orange, size: 32),
                    title: Text(
                      station['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("📍 ${station['location']}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Status: ${station['status']}"),
                        Text("📞 ${station['number']}"),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Login Required"),
                          content: Text(
                            "Please log in to order from ${station['name']}.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/authpage');
                              },
                              child: Text("Login"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


void _showAboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationIcon: Image.asset(
      'assets/images/delivery-with-white-background-1.png',
      width: 60,
      height: 60,
    ),
    applicationName: "Fill'd",
    applicationVersion: 'v1.0.0',
    applicationLegalese: "© 2025 Fill'd.",
    children: [
      SizedBox(height: 10),
      Text(
        "Fill'd is a gas delivery app that connects clients with trusted gas companies through verified gas delivery riders.\n\n"
            '👥 Clients can easily find nearby gas stations and request for home delivery.\n\n'
            '🛵 Riders are assigned to deliver gas safely and efficiently.\n\n'
            'Built to make gas access simpler, faster, and safer.',
        style: TextStyle(fontSize: 14),
      ),
    ],
  );
}
double gasAmount = 0.0;
double deliveryAmount = 0.0;

// Method to calculate the total amount including gas and delivery charges
double calculateTotal(double enteredAmount, DirectionDetails directionDetails) {
  // Calculate service charge as 5% of the entered amount
  double serviceCharge = enteredAmount * 0.05;

  // Calculate delivery fare based on direction details
  // deliveryAmount = AssistantMethods.calculateFares(directionDetails);

  // Total cost including cylinder price, service charge, and delivery fare
  return enteredAmount + serviceCharge + deliveryAmount;
}


// Method to show the explanation dialog with breakdown
void showCalculationDialog(BuildContext context) {
  // double totalAmount = calculateTotal();

  // Show the dialog with the explanation
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Calculation Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Cylinder Price: \$$30"),
              // SizedBox(height: 10),
              // Text("Service Charge (5%): \$${(enteredAmount * 0.05).toStringAsFixed(2)}"),
              // SizedBox(height: 10),
              // Text("Delivery Fare: \$${deliveryAmount.toStringAsFixed(2)}"),
              // SizedBox(height: 10),
              // Text("Total: \$${totalAmount.toStringAsFixed(2)}"),
              // SizedBox(height: 20),
              Text(
                "Explanation:\n\n"
                    "1. The service charge is 5% of the amount you want to spend on the cylinder.\n"
                    "2. Delivery fare is calculated based on the distance and time it takes to deliver the gas to you.\n"
                    "   - If the distance is less than 500 meters, a flat fee of \GHS5 is applied.\n"
                    "   - Otherwise, the fare is calculated as \GHS0.011 per meter traveled.\n"
                    "   - The time fare is calculated based on the time it takes to complete the delivery, at a rate of \GHS0.20 per minute.\n\n"
                    "This breakdown gives you a clear idea of how the charges are applied.",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.orange)),
          ),
        ],
      );
    },
  );
}

// Example usage of the above method
void exampleUsage(BuildContext context) {
  // Example user input
  double enteredAmount = 100.0; // Amount the user wants to spend on the cylinder
  DirectionDetails directionDetails = DirectionDetails(distanceValue: 5000, durationValue: 300);

  // Show the calculation dialog
  showCalculationDialog(context);
}

// Dummy class to simulate direction details (distance and time)
class DirectionDetails {
  final int? distanceValue;
  final int? durationValue;

  DirectionDetails({this.distanceValue, this.durationValue});
}
Widget _buildActionCard({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}


