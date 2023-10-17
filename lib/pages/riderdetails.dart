import 'dart:io';
import 'package:filld_rider/pages/Authpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Riderdetails extends StatefulWidget {
  const Riderdetails({Key? key}) : super(key: key);

  @override
  State<Riderdetails> createState() => _RiderdetailsState();
}

class _RiderdetailsState extends State<Riderdetails> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('Riders');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  File? _riderImage;
  File? _licenseImage;
  File? _insuranceImage;

  String _numberPlate = '';
  String _motorType = '';
  String _licensePlateNumber = '';
  String motorcolor = '';

  Future<void> _pickImage(ImageSource source, Function(File) setImage) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Handle user not logged in
      return;
    }

    // Upload images to Firebase Storage
    final riderImageUrl = await _uploadImageToStorage(_riderImage);
    final licenseImageUrl = await _uploadImageToStorage(_licenseImage);
    final insuranceImageUrl = await _uploadImageToStorage(_insuranceImage);

    // Create a map of user data to update in the Realtime Database
    final Map<String, dynamic> profileData = {
      'riderImageUrl': riderImageUrl,
      // 'licenseImageUrl': licenseImageUrl,
      'Motor-Color': motorcolor,
      // 'insuranceImageUrl': insuranceImageUrl,
      // 'numberPlate': _numberPlate,
      'motorType': _motorType,
      'licensePlateNumber': _licensePlateNumber,
    };

    await databaseReference.child(currentUser.uid).child("car_details").update(profileData);

    // Profile updated successfully
    // You can navigate to a different screen or show a success message
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>AuthPage()
    ),
    );}

  Future<String> _uploadImageToStorage(File? imageFile) async {
    if (imageFile == null) {
      return ''; // Return an empty string if no image is provided
    }

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    final String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildImagePicker(
              title: 'Rider Image',
              setImage: (File image) {
                setState(() {
                  _riderImage = image;
                });
              },
            ),


            TextFormField(
              decoration: InputDecoration(labelText: 'Motor Type'),
              onChanged: (value) {
                setState(() {
                  _motorType = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Motor-Color'),
              onChanged: (value) {
                setState(() {
                  motorcolor = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'License Plate Number'),
              onChanged: (value) {
                setState(() {
                  _licensePlateNumber = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({required String title, required Function(File) setImage}) {
    return Column(
      children: <Widget>[
        Text("ProfileImage",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 8),

        CircleAvatar(
          radius: 50, // Adjust the radius as needed
          backgroundColor: Colors.blue, // Background color of the avatar
          child: _riderImage != null
              ? ClipOval(
            child: Image.file(
              _riderImage!,
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the BoxFit as needed
            ),
          )
              : GestureDetector(
    onTap: () {
        _pickImage(ImageSource.gallery, setImage);
      },

                child: ClipOval(
            child: Image.asset(
                "assets/images/profile-image.png",
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
                fit: BoxFit.cover, // Adjust the BoxFit as needed
            ),
          ),
              ),
        ),
        SizedBox(height: 10),

        // _buildImagePreview(setImage),
        // ElevatedButton(
        //   onPressed: () {
        //     _pickImage(ImageSource.gallery, setImage);
        //   },
        //   child: Text('Pick from Gallery'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     _pickImage(ImageSource.camera, setImage);
        //   },
        //   child: Text('Take a Photo'),
        // ),
      ],
    );
  }
  Widget  _buildImagePreview(Function(File) setImage) {
    if (setImage == null) {
      return SizedBox.shrink();
    }
    return _riderImage != null
        ? Image.file(_riderImage!)
        :  Image.asset("assets/images/profile-image.png"); // Display a placeholder or nothing if no image is set
  }
}

