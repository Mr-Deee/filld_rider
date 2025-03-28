import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerSupportService extends StatefulWidget {
  const CustomerSupportService({super.key});

  @override
  State<CustomerSupportService> createState() => _CustomerSupportServiceState();
}

class _CustomerSupportServiceState extends State<CustomerSupportService> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // State variables
  String? selectedIssue;
  File? imageFile;
  List<Map<String, dynamic>> userRequests = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserRequests();
  }

  Future<void> _fetchUserRequests() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final ref = _database.ref("Riders/${user.uid}/css");
        final snapshot = await ref.get();

        if (snapshot.exists) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            userRequests = data.values
                .map((value) => Map<String, dynamic>.from(value))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching requests: $e");
    }
  }

  Future<void> _submitRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final requestData = {
          'UserId': user.uid,
          'title': titleController.text,
          'description': descriptionController.text,
          'issue': selectedIssue,
          'status': 'open',
          'WMSTYPE': 'Client',
          'timestamp': DateTime.now().toIso8601String(),
        };

        if (imageFile != null) {
          final imageRef = _storage.ref().child(
              'screenshots/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await imageRef.putFile(imageFile!);
          requestData['imageUrl'] = await imageRef.getDownloadURL();
        }

        final ref = _database.ref("Riders/${user.uid}/css");
        final refcss = _database.ref("customerSupportRequests");

        await ref.push().set(requestData);
        await refcss.push().set(requestData);

        setState(() {
          titleController.clear();
          descriptionController.clear();
          selectedIssue = null;
          imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request submitted successfully.")),
        );

        _fetchUserRequests();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting request: $e")),
      );
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Support Service"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildForm(),
            const SizedBox(height: 24),
            _buildPreviousRequests(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Request Type',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            value: selectedIssue,
            items: ['Bug Report', 'Account Issue', 'Feature Request', 'Other']
                .map((issue) =>
                    DropdownMenuItem(value: issue, child: Text(issue)))
                .toList(),
            onChanged: (value) => setState(() => selectedIssue = value),
            validator: (value) =>
                value == null ? 'Please select a request type' : null,
          ),
          const SizedBox(height: 16),
          if (selectedIssue == 'Other') _buildOtherIssueFields(),
          if (selectedIssue != 'Other') _buildDescriptionField(),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Card(child: Icon(Icons.image))),
              ),

            ],
          ),



          GestureDetector(
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _submitRequest();
                }
              },
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
              )),
          // ElevatedButton.icon(
          //   onPressed: _pickImage,
          //   icon: const
          //    label: const Text(""),
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //   ),
          //),
          const SizedBox(height: 8),
          if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(imageFile!,
                  height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          // ElevatedButton(
          //   onPressed: () {
          //     if (_formKey.currentState?.validate() ?? false) {
          //       _submitRequest();
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12)),
          //   ),
          //   child: const Text("Submit Request"),
          // ),
        ],
      ),
    );
  }

  Widget _buildOtherIssueFields() {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Custom Title',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 16),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Provide detailed information',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: 4,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter a description' : null,
    );
  }

  Widget _buildPreviousRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Previous Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (userRequests.isEmpty)
          const Text("No requests found.",
              style: TextStyle(color: Colors.grey)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userRequests.length,
          itemBuilder: (context, index) {
            final request = userRequests[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(request['issue'] ?? "No Title"),
                subtitle: Text(request['description'] ?? "No Description"),
                trailing: Text(request['timestamp']?.split('T').first ?? ""),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
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
                  'Your privacy is important to us. Benjis Rental ensures that your data is protected and used responsibly. For more information, contact us.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('Close', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
