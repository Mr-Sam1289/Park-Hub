
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:smartparkin1/slot.dart';

class VehicleDetailsPage extends StatefulWidget {
  const VehicleDetailsPage({super.key});

  @override
  State<VehicleDetailsPage> createState() => VehicleDetailsPageState();
}

class VehicleDetailsPageState extends State<VehicleDetailsPage> {
  final Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> userVehicleDetails = [];

  String? vehicleType;
  String vehicleNumber = '';
  String licenseNumber = '';

  @override
  void initState() {
    super.initState();
    // Load user's vehicle details when the widget is first created
    loadUserVehicleDetails();
  }


  Future<void> loadUserVehicleDetails() async {
    try {
      List<Map<String, dynamic>> details = await _getUserVehicleDetails();
      setState(() {
        userVehicleDetails = details;
      });
    } catch (e) {
      // Handle errors
      logger.i('Error loading user vehicle details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getUserVehicleDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String email = user.email ?? "";
      String documentName = sanitizeEmail(email);

      // Reference to the user's document
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('Vehicle Details').doc(documentName);

      // Get all documents within the 'Vehicles' subcollection
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await userDocRef.collection(vehicleNumber).get(); // Use the correct subcollection name

      // Extract data from documents
      List<Map<String, dynamic>> vehicleDetailsList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        // Fetch the details from each document
        Map<String, dynamic> vehicleDetails = doc.data();
        vehicleDetailsList.add(vehicleDetails);
      }

      return vehicleDetailsList;
    } else {
      throw Exception('User not signed in');
    }
  }

  List<String> vehicleTypes = ['Car', 'Motorcycle', 'Truck', 'Other'];

  Future<void> addVehicleDetails(
      String vehicleType, String vehicleNumber, String licenseNumber) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use user.email as the document name
        String email = user.email ?? "";
        String documentName = sanitizeEmail(email);

        // Reference to the user's document
        DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Vehicle Details').doc(documentName);

        // Add vehicle details to a subcollection named 'vehicleNumber'
        await userDocRef.collection(vehicleNumber).add({
          'vehicleType': vehicleType,
          'vehicleNumber': vehicleNumber,
          'licenseNumber': licenseNumber,
        });

        // Log success or handle further logic
        logger.i('Vehicle details added successfully for user: $documentName');
      } else {
        // Handle the case where the user is not signed in
        logger.e('User not signed in. Cannot add vehicle details.');
      }
    } catch (e) {
      // Handle errors
      logger.e('Error adding vehicle details: $e');
    }
  }





  String sanitizeEmail(String email) {
    // Replace special characters and use a hash function if needed
    return email.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  void _showVehicleDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Text(
                    'Enter Vehicle Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: vehicleType,
                    items: vehicleTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        vehicleType = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Type',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vehicle type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Number',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        vehicleNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter vehicle number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'License Number',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        licenseNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter license number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            addVehicleDetails(
                                vehicleType!, vehicleNumber, licenseNumber);
                            Navigator.pop(context);
                            loadUserVehicleDetails();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      if (value != null) {
        setState(() {
          vehicleNumber = value;
        });
        await loadUserVehicleDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Vehicle Details",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Your Vehicles',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )),
            // Display containers for each saved vehicle
            for (Map<String, dynamic> vehicleDetails in userVehicleDetails)
              Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  const SelectSlotPage()));
                  },
                  child: ListTile(
                    title: Text(
                      'Vehicle Type: ${vehicleDetails['vehicleType']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Number: ${vehicleDetails['vehicleNumber']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'License Number: ${vehicleDetails['licenseNumber']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 40,),
            GestureDetector(
              onTap: () {
                _showVehicleDetailsBottomSheet(context);
              },
              child: Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const ListTile(
                  title: Text(
                    'New Vehicle?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
