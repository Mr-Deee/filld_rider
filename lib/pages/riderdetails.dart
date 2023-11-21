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
  File? _GhanaCardImage;

  String _numberPlate = '';
  String _motorType = '';
  String _nextofkin = '';
  String _nextofkinnum = '';
  String _nextofkinrelationship = '';
  String _licensePlateNumber = '';
  String _GHCardNumber = '';
  String _location = '';
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
    final licenseImageUrl = await licenseImageUrltostorage(_licenseImage);
    final insuranceImageUrl = await _uploadImageToStorage(_insuranceImage);
    final GhanaCardUrl = await _uploadImageToGhanaCardUrl(_GhanaCardImage);

    final Map<String, dynamic> userprofile = {
      'NextofKinName': _nextofkin,
      'NextofKinNumber': _nextofkinnum,
      'NextofKinRelationship': _nextofkinrelationship,
      'location': _location,
    };
    await databaseReference.child(currentUser.uid).update(userprofile);

    // Create a map of user data to update in the Realtime Database


    final Map<String, dynamic> profileData = {
      'riderImageUrl': riderImageUrl,
      'riderLicense': licenseImageUrl,
      'GhanaCardUrl': GhanaCardUrl,
      'autombileColor': motorcolor,
      'type': "bike",
      'motorBrand': _motorType,

      'licensePlateNumber': _licensePlateNumber,
      'GhanaCardNumber': _GHCardNumber,
    };

    await databaseReference.child(currentUser.uid).child("car_details").update(profileData);
    await databaseReference.child(currentUser.uid).update({'status':'deactivated'});

    // Profile updated successfully
    // You can navigate to a different screen or show a success message
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>AuthPage()
    ),
    );}

  Future<String> licenseImageUrltostorage(File? imageFile) async {
    if (imageFile == null) {
      return ''; // Return an empty string if no image is provided
    }

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('licenseImageUrl/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    final String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  }
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
  Future<String> _uploadImageToGhanaCardUrl(File? imageFile) async {
    if (imageFile == null) {
      return ''; // Return an empty string if no image is provided
    }

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('GhanaCardUrl/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    final String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: Text('Rider Profile',style: TextStyle(color: Colors.black),),
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

            SizedBox(height: 19,),
            Container(
              height: size.width / 7,
              width: size.width / 2.2,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  right: size.width / 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(



                decoration: InputDecoration(
                    labelText: 'Motor Type',
                prefixIcon: Icon(
                  Icons.motorcycle,
                  color: Colors.black,
                ),
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'Kawasaki...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),),
                onChanged: (value) {
                  setState(() {
                    _motorType = value;
                  });
                },
              ),
            ),
            SizedBox(height: 19,),
            Container(

              height: size.width / 7,
              width: size.width / 2.2,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  right: size.width / 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                decoration: InputDecoration(  labelText: 'Color',
                    prefixIcon: Icon(
                      Icons.color_lens,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    hintMaxLines: 1,
                    hintText: 'Black...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    )),
                onChanged: (value) {
                  setState(() {
                    motorcolor = value;
                  });
                },
              ),
            ),
            SizedBox(height: 9,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

           Container(
               height: 70,
               width: 170
               ,
               child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListView(
                      children: <Widget>[


                        _buildImagePickerLicene(
                          title: 'Upload LicenseImage',
                          setImage: (File image) {
                            setState(() {
                              _licenseImage = image;
                            });
                          },
                        ),])),
           ),


                  Container(
                    height: size.width / 7,
                    width: size.width / 2.1,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        right: size.width / 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration( prefixIcon: Icon(
                        Icons.numbers_rounded,
                        color: Colors.black,
                      ),
                          border: InputBorder.none,
                          hintMaxLines: 1,
                          hintText: 'XXXXX..',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),labelText: 'License Plate Number'),
                      onChanged: (value) {
                        setState(() {
                          _licensePlateNumber = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  Container(
                    height: 70,
                    width: 170
                    ,
                    child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ListView(
                            children: <Widget>[


                              _buildImagePickerGHCARD(
                                title: 'Upload Ghana Card',
                                setImage: (File image) {
                                  setState(() {
                                    _GhanaCardImage = image;
                                  });
                                },
                              ),])),
                  ),


                  Container(
                    height: size.width / 7,
                    width: size.width / 2.1,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        right: size.width / 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration( prefixIcon: Icon(
                        Icons.numbers_rounded,
                        color: Colors.black,
                      ),
                          border: InputBorder.none,
                          hintMaxLines: 1,
                          hintText: 'GHA-XXXXXX...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),labelText: 'GHCard Number'),
                      onChanged: (value) {
                        setState(() {
                          _GHCardNumber = value;
                        });
                      },
                    ),
                  ),



                ],
              ),
            ),

            Divider(
              color: Colors.black,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(height: 19,),
        Text('Next Of Kin',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Container(
                  height: size.width / 7,
                  width: size.width / 2.2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      right: size.width / 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(



                    decoration: InputDecoration(
                      labelText: 'Next Of Kin',
                      prefixIcon: Icon(
                        Icons.next_plan,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintMaxLines: 1,
                      hintText: 'Kwaku..',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),),
                    onChanged: (value) {
                      setState(() {
                        _nextofkin = value;
                      });
                    },
                  ),
                ),
                Container(
                  height: size.width / 7,
                  width: size.width / 2.2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      right: size.width / 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(



                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintMaxLines: 1,
                      hintText: '+233....',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),),
                    onChanged: (value) {
                      setState(() {
                        _nextofkinnum = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 19,),
            Row(
              children: [
                Container(
                  height: size.width / 7,
                  width: size.width / 2.2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      right: size.width / 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(



                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(
                        Icons.my_location,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintMaxLines: 1,
                      hintText: 'Tema..',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),),
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                  ),
                ),
                Container(
                  height: size.width / 7,
                  width: size.width / 2.2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      right: size.width / 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Relationship',
                      prefixIcon: Icon(
                        Icons.family_restroom,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintMaxLines: 1,
                      hintText: 'Mother...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),),
                    onChanged: (value) {
                      setState(() {
                        _nextofkinrelationship = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 19,),

            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
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
        SizedBox(height: 14),

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


  Widget _buildImagePickerLicene({required String title, required Function(File) setImage}) {
    return Column(
      children: <Widget>[
        Text("Upload License",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height:10),

        CircleAvatar(
          radius: 20, // Adjust the radius as needed
          backgroundColor: Colors.blue, // Background color of the avatar
          child: _licenseImage != null
              ? ClipOval(
            child: Image.file(
              _licenseImage!,
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
                "assets/images/IMPORT.png",

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


  Widget _buildImagePickerGHCARD({required String title, required Function(File) setImage}) {
    return Column(
      children: <Widget>[
        Text("Upload Ghana Card",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height:10),

        CircleAvatar(
          radius: 20, // Adjust the radius as needed
          backgroundColor: Colors.blue, // Background color of the avatar
          child: _GhanaCardImage != null
              ? ClipOval(
            child: Image.file(
              _GhanaCardImage!,
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
                "assets/images/IMPORT.png",
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

