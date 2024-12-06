import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../Models/Ride_r.dart';
import 'CSS.dart';

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

      body: SingleChildScrollView(
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

  Widget _buildProfileHeader() {

    final rideprovider = Provider.of<Ride_r>(context).riderInfo;
    var username = rideprovider?.firstname;
    var email = rideprovider?.email;
    var license = rideprovider?.automobile_model;
    return Stack(
      children: [
        Container(
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 80),
              CircleAvatar(
                radius: 70,
                backgroundImage: CachedNetworkImageProvider(
                  rideprovider!.profilepicture!, // Replace with actual image URL
                ),
              ),
              SizedBox(height: 10),
              Text("$username",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                emailController.text.isNotEmpty ? emailController.text : "email@example.com",
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
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInfoRow(Icons.phone, "Phone", phoneController.text.isNotEmpty ? phone.toString():""),
              Divider(),
              _buildInfoRow(Icons.motorcycle, "Motor Brand", Brand!),
              Divider(),
              _buildInfoRow(Icons.card_membership, "License", license!),
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
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildActionItem(Icons.call, "Customer Support Service", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerSupportService()),
              );            }),
            Divider(),
            _buildActionItem(Icons.info, "About", () {
              // Navigate to about page
            }),
            Divider(),
            _buildActionItem(Icons.privacy_tip, "Privacy Policy", () {
              // Navigate to privacy policy
            }),
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
}
