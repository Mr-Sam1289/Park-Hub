import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smartparkin1/MapsPage.dart';
import 'slot.dart'; // Import the SlotPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ParkingApp(),
    );
  }
}

class ParkingApp extends StatefulWidget {
  const ParkingApp({super.key});
  @override
  ParkingAppState createState() => ParkingAppState();
}

class ParkingAppState extends State<ParkingApp> {
  DateTime _selectedDateTime = DateTime.now();
  List<String> availableParkingTimes = ['1 hr', '3 hrs', '4 hrs'];

  void _updateSelectedDateTime(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? pickedDateTime = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return _buildCupertinoDatePicker(context);
      },
    );

    if (pickedDateTime != null) {
      _updateSelectedDateTime(pickedDateTime);
    }
  }

  Widget _buildCupertinoDatePicker(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .copyWith()
          .size
          .height / 3,
      color: Colors.white,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: _selectedDateTime,
        onDateTimeChanged: (DateTime newDateTime) {
          _updateSelectedDateTime(newDateTime);
        },
      ),
    );
  }

  void _bookParking(String selectedTime) {
    showBookingConfirmation(selectedTime);
  }

  void showBookingConfirmation(String selectedTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: Text('Parking spot booked at ${_formatDateTime(
              _selectedDateTime)} for $selectedTime.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String formattedDateTime = DateFormat('MMMM d,  h:mm a').format(dateTime);
    return formattedDateTime;
  }

  void _navigateToSlotPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectSlotPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Asset Container for Background
          Container(
            color: Colors.black,
            height: MediaQuery
                .of(context)
                .size
                .height / 2, // Half of the screen height
            child: Image.asset(
              'assets/images/clock2.avif', // Replace with your asset path
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
          // White bottom part
          Container(
            color: Colors.white,
            height: MediaQuery
                .of(context)
                .size
                .height / 2, // Half of the screen height
            child: Column(
              children: [
                // Select Date and Time button
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _selectDateTime(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'When do you want to arrive?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // The list of available parking times.
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableParkingTimes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Center(
                              child: Text(availableParkingTimes[index])),
                          onTap: () {
                            _bookParking(availableParkingTimes[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Date and time at the bottom center
                Text(
                  _formatDateTime(_selectedDateTime),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MapsPage()));
                        // TODO: Implement the back button functionality.
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the SlotPage when the Next button is clicked
                        _navigateToSlotPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
