import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'edit_item.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  EditAccountScreenState createState() => EditAccountScreenState();
}

class EditAccountScreenState extends State<EditAccountScreen> {
  final Logger logger = Logger();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _isPasswordObscured = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();

    // Fetch user details from Firestore when the screen is initialized
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      getDocId(_currentUser!.email!);
    }
  }

  Future<void> getDocId(String userEmail) async {
    try {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userDocs.docs.first;
        setState(() {
          _firstNameController.text = userDoc['firstName'];
          _lastNameController.text = userDoc['lastName'];
          _passwordController.text = userDoc['password'];
          _userNameController.text = userDoc['userName'].toString();
          _emailController.text = userDoc['email'];
          _mobileController.text = userDoc['mobileNumber'];
          _pickedImage = userDoc['profilePicture'] != null ? File(userDoc['profilePicture']) : null;
        });
      }
    } catch (error) {
      logger.i('Error fetching user details: $error');
    }
  }

  File? _pickedImage;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (error) {
      logger.i('Error picking image: $error');
      // Handle error gracefully, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking image. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImage == null) return null;

    try {
      String storagePath = 'gs://smartparking-79613.appspot.com/profilePictures/${_currentUser?.email ?? ''}';
      UploadTask uploadTask = FirebaseStorage.instance.ref(storagePath).putFile(_pickedImage!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the user document with the new image URL
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser?.email)
          .update({'profilePicture': downloadUrl});

      return downloadUrl;
    } catch (error) {
      logger.i('Error uploading image: $error');
      // Handle error gracefully, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading image. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.lightBlueAccent,
        fontFamily: 'Roboto',
      ),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.blue.shade500],
              ),
            ),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  EditItem(
                    title: "Photo",
                    widget: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Hero(
                            tag: "user_photo",
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: _pickedImage != null
                                      ? FileImage(_pickedImage!)
                                      : const AssetImage("assets/images/avatar3.png") as ImageProvider<Object>,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickImage,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                          child: const Text("Upload Image"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "First Name",
                    widget: TextField(
                      controller: _firstNameController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "Last Name",
                    widget: TextField(
                      controller: _lastNameController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "User Name",
                    widget: TextField(
                      controller: _userNameController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "Email",
                    widget: TextField(
                      controller: _emailController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "Mobile",
                    widget: TextField(
                      controller: _mobileController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditItem(
                    title: "Password",
                    widget: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _isPasswordObscured,
                            enabled: false,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // ... Other form fields
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Handle edit profile logic here
                        String? imageUrl = await _uploadImage();
                        if (imageUrl != null) {
                          // Do something with the imageUrl, e.g., update Firestore
                          // Example: updateFirestore(imageUrl);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text("Edit Profile"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
