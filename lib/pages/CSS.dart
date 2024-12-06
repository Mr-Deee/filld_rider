import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
            userRequests = data.values.map((value) => Map<String, dynamic>.from(value)).toList();
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
          final imageRef = _storage.ref().child('screenshots/${DateTime.now().millisecondsSinceEpoch}.jpg');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildForm(),
            const SizedBox(height: 32),
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
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select Request Title'),
            value: selectedIssue,
            items: ['Bug Report', 'Account Issue', 'Feature Request', 'Other']
                .map((issue) => DropdownMenuItem(value: issue, child: Text(issue)))
                .toList(),
            onChanged: (value) => setState(() => selectedIssue = value),
            validator: (value) => value == null ? 'Please select a request title' : null,
          ),
          const SizedBox(height: 16),
          if (selectedIssue == 'Other') _buildOtherIssueFields(),
          if (selectedIssue != 'Other') _buildDescriptionField(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text("Upload Screenshot"),
          ),
          const SizedBox(height: 8),
          if (imageFile != null) Image.file(imageFile!, height: 150, fit: BoxFit.cover),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _submitRequest();
              }
            },
            child: const Text("Submit Request"),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherIssueFields() {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Enter Title'),
          validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 8),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: 'Enter Description',
        hintText: 'Provide detailed information',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: 4,
      validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
    );
  }

  Widget _buildPreviousRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Previous Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (userRequests.isEmpty)
          const Text("No requests found."),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userRequests.length,
          itemBuilder: (context, index) {
            final request = userRequests[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(request['issue'] ?? "No Title"),
                subtitle: Text(request['description'] ?? "No Description"),
                trailing: Text(request['timestamp']?.split(' ').first ?? ""),
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
}
