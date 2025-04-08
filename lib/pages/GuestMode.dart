import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Guest Mode"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _gasStations.isEmpty && isRiderLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Browse Nearby Gas Stations...',
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                  speed: Duration(milliseconds: 80),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            const SizedBox(height: 20),
            _buildRiderInfoCard(),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
