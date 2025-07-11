import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../Models/Ride_r.dart';
import 'CSS.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class ProfileTabPage extends StatefulWidget {
  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  bool _isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    var username = rideprovider?.firstname;
    var email = rideprovider?.email;
    var phone = rideprovider?.phone;
    nameController.text = rideprovider?.firstname ?? '';
    emailController.text = rideprovider?.email ?? '';
    phoneController.text = rideprovider?.phone ?? '';
    // motorBrandController.text = rideprovider?.automobile_model ?? '';
    // motorColorController.text = rideprovider?.automobile_model ?? '';
    // riderLicenseController.text = rideprovider?.plate_number ?? '';
    // riderGhanaCard.text = rideprovider?.GhanaCard ?? '';
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20), // Add some padding if needed

        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildInfoSection(),
            _buildActionsSection(context),
          ],
        ),
      ),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          backgroundColor: Colors.black,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you certain you want to Sign Out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                print('yes');
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    var username = rideprovider?.firstname;
    var email = rideprovider?.email;
    var license = rideprovider?.automobile_model;
    return Stack(
      children: [
        Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 50,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {


                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign Out'),
                        backgroundColor: Colors.white,
                        content: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Text('Are you certain you want to Sign Out?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              print('yes');
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/authpage", (route) => false);
                              // Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 60),
              CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(
                  rideprovider!
                      .profilepicture??"assets/images/delivery-with-white-background-1.png", // Replace with actual image URL
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$username",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                emailController.text.isNotEmpty
                    ? emailController.text
                    : "email@example.com",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    var license = rideprovider?.plate_number;
    var Brand = rideprovider?.automobile_model;

    var email = rideprovider?.email;
    var phone = rideprovider?.phone;
    return Padding(
      padding: const EdgeInsets.only(left: 14.0,right: 14.0,top: 3),
      child: Card(
        color: Colors.white,

        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInfoRow(Icons.phone, "Phone",
                  phoneController.text.isNotEmpty ? phone.toString() : ""),
              Divider(),
              _buildInfoRow(Icons.motorcycle, "Motor Brand", Brand??""),
              Divider(),
              _buildInfoRow(Icons.card_membership, "License", license??""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,right: 16,left: 16),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildActionItem(Icons.call, "Customer Support Service", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerSupportService()),
              );
            }),
            Divider(),
            _buildActionItem(Icons.info, "About", () {
              _showAboutDialog(context);
            }),
            Divider(),
            _buildActionItem(Icons.privacy_tip, "Privacy Policy", () {
              _showPrivacyDialog(context);
              // Navigate to privacy policy
            }),

            Divider(),
            _buildActionItem(Icons.delete, "Delete Account", () {
              _showDeleteDialog(context);
              // Navigate to privacy policy
            }),
            SizedBox(height: 2,)
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout functionality
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, size: 50, color: Colors.white70),
                  const SizedBox(height: 20),
                  Text(
                    'Our Mission, Vision & Core Values',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'We aim to become the industry leader in the LPG Gas Delivery in Ghana by consistently innovating and providing top-notch customer experiences. Below are our core values:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildHoverCardWithPopup(
                        context: context,
                        icon: Icons.lightbulb_outline,
                        title: 'Innovation',
                        description:
                        'We constantly innovate to meet customer needs efficiently.',
                      ),
                      _buildHoverCardWithPopup(
                        context: context,
                        icon: Icons.handshake_outlined,
                        title: 'Customer Focus',
                        description:
                        'Customer satisfaction is at the heart of everything we do.',
                      ),

                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoverCardWithPopup({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return MouseRegion(
      onEnter: (event) {
        // _showPopup(context, title, description);
      },
      onExit: (event) {
        Navigator.pop(context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 50, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your privacy is important to us.FillD , ensures that your data is protected and used responsibly. For more information, contact us.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

  Future<void> _deleteUserData(String uid) async {
    // 👇 Uncomment this for Realtime Database
    final dbRef = FirebaseDatabase.instance.ref("Riders/$uid");
    await dbRef.remove();

    // 👇 Or, use this for Firestore
    // await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  Future<void> _deleteUserAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final uid = user.uid;

        // First delete user data from DB
        await _deleteUserData(uid);

        // Then delete the user from Auth
        await user.delete();

        // Navigate to the signup screen and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil('/authpage', (route) => false);

        // Optional: Show a message on signup screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account successfully deleted.')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please log in again to delete your account.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              _deleteUserAccount(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
