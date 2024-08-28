import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:filld_rider/pages/Authpage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class Riderdetails extends StatefulWidget {
  const Riderdetails({Key? key}) : super(key: key);

  @override
  State<Riderdetails> createState() => _RiderDetailsState();
}

class _RiderDetailsState extends State<Riderdetails> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('Riders');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  File? _riderImage;
  File? _licenseImage;
  File? _insuranceImage;
  File? _ghanaCardImage;

  String _numberPlate = '';
  String _motorType = '';
  String _nextOfKin = '';
  String _nextOfKinNum = '';
  String _nextOfKinRelationship = '';
  String _licensePlateNumber = '';
  String _ghanaCardNumber = '';
  String _location = '';
  String _motorColor = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data when the app starts
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _motorType = prefs.getString('motorType') ?? '';
      _motorColor = prefs.getString('motorColor') ?? '';
      _nextOfKin = prefs.getString('nextOfKin') ?? '';
      _nextOfKinNum = prefs.getString('nextOfKinNum') ?? '';
      _nextOfKinRelationship = prefs.getString('nextOfKinRelationship') ?? '';
      _licensePlateNumber = prefs.getString('licensePlateNumber') ?? '';
      _ghanaCardNumber = prefs.getString('ghanaCardNumber') ?? '';
      _location = prefs.getString('location') ?? '';
    });
  }

  Future<void> _saveDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('motorType', _motorType);
    prefs.setString('motorColor', _motorColor);
    prefs.setString('nextOfKin', _nextOfKin);
    prefs.setString('nextOfKinNum', _nextOfKinNum);
    prefs.setString('nextOfKinRelationship', _nextOfKinRelationship);
    prefs.setString('licensePlateNumber', _licensePlateNumber);
    prefs.setString('ghanaCardNumber', _ghanaCardNumber);
    prefs.setString('location', _location);
  }

  Future<void> _pickImage(ImageSource source, Function(File) setImage) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
      _saveDataLocally(); // Save the state after picking an image
    }
  }

  Future<void> _saveProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(15.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    SizedBox(width: 20),
                    Text("Updating Your Details, please wait...")
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    try {
      // Upload images to Firebase Storage in parallel
      final futures = [
        _uploadImageToStorage(_riderImage, 'riderImageUrl'),
        _uploadImageToStorage(_licenseImage, 'licenseImageUrl'),
        _uploadImageToStorage(_insuranceImage, 'insuranceImageUrl'),
        _uploadImageToStorage(_ghanaCardImage, 'ghanaCardUrl')
      ];

      final results = await Future.wait(futures);
      final riderImageUrl = results[0];
      final licenseImageUrl = results[1];
      final insuranceImageUrl = results[2];
      final ghanaCardUrl = results[3];

      final userProfile = {
        'NextofKinName': _nextOfKin,
        'NextofKinNumber': _nextOfKinNum,
        'NextofKinRelationship': _nextOfKinRelationship,
        'location': _location,
        'riderImageUrl': riderImageUrl,
        'detailsComp': true,
      };

      final profileData = {
        'riderImageUrl': riderImageUrl,
        'riderLicense': licenseImageUrl,
        'ghanaCardUrl': ghanaCardUrl,
        'motorColor': _motorColor,
        'type': "bike",
        'motorBrand': _motorType,
        'licensePlateNumber': _licensePlateNumber,
        'ghanaCardNumber': _ghanaCardNumber,
        'status': 'deactivated'
      };

      await Future.wait([
        databaseReference.child(currentUser.uid).update(userProfile),
        databaseReference.child(currentUser.uid).child("car_details").update(profileData),
      ]);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    } catch (e) {
      // Handle any errors here
    }
  }

  Future<String> _uploadImageToStorage(File? imageFile, String path) async {
    if (imageFile == null) {
      return ''; // Return an empty string if no image is provided
    }

    final storageReference = FirebaseStorage.instance.ref().child('$path/${DateTime.now().toString()}');
    final uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Create Your Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildImagePicker(
              title: 'Upload Profile Image',
              image: _riderImage,
              onImagePicked: (File image) {
                setState(() => _riderImage = image);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Motor Type',
              icon: Icons.motorcycle,
              hintText: 'Kawasaki...',
              onChanged: (value) {
                setState(() => _motorType = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Color',
              icon: Icons.color_lens,
              hintText: 'Black...',
              onChanged: (value) {
                setState(() => _motorColor = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImagePicker(
                  title: 'Upload License Image',
                  image: _licenseImage,
                  onImagePicked: (File image) {
                    setState(() => _licenseImage = image);
                    _saveDataLocally();
                  },
                ),
                _buildImagePicker(
                  title: 'Upload Ghana Card',
                  image: _ghanaCardImage,
                  onImagePicked: (File image) {
                    setState(() => _ghanaCardImage = image);
                    _saveDataLocally();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'License Plate Number',
              icon: Icons.numbers_rounded,
              hintText: 'XXXXX..',
              onChanged: (value) {
                setState(() => _licensePlateNumber = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'GHCard Number',
              icon: Icons.numbers_rounded,
              hintText: 'GHA-XXXXXX...',
              onChanged: (value) {
                setState(() => _ghanaCardNumber = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Location',
              icon: Icons.my_location,
              hintText: 'Tema..',
              onChanged: (value) {
                setState(() => _location = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Next Of Kin',
              icon: Icons.next_plan,
              hintText: 'Kwaku..',
              onChanged: (value) {
                setState(() => _nextOfKin = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              hintText: '+233....',
              onChanged: (value) {
                setState(() => _nextOfKinNum = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Relationship',
              icon: Icons.family_restroom,
              hintText: 'Mother...',
              onChanged: (value) {
                setState(() => _nextOfKinRelationship = value);
                _saveDataLocally();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _saveProfile,
              child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String title,
    required File? image,
    required Function(File) onImagePicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 14),
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: image != null
                    ? Image.file(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery, onImagePicked),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
