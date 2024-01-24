import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smartparkin1/MapsPage.dart';
import 'package:smartparkin1/vehicle_details_page.dart';

class DateAndTime extends StatelessWidget {
  const DateAndTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ParkingApp(),
    );
  }
}

class CountController extends StatelessWidget {
  final int count;
  final ValueSetter<int> onChanged;

  const CountController({super.key, required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'Decrement',
          onPressed: () => onChanged(count > 0 ? count - 1 : count),
          backgroundColor: Colors.black,
          child: const Icon(Icons.remove, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Text(
          '$count',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          heroTag: 'Increment',
          onPressed: () => onChanged(count + 1),
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
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
  int _selectedHours = 0;

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
      height: MediaQuery.of(context).copyWith().size.height / 3,
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

  String _formatDateTime(DateTime dateTime) {
    String formattedDateTime = DateFormat('MMMM d,  h:mm a').format(dateTime);
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildBackgroundContainer(),
          _buildBottomContainer(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height / 2,
      child: Image.asset(
        'assets/images/clock2.avif',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          _buildSelectDateTimeButton(),
          Text(_formatDateTime(_selectedDateTime), style: const TextStyle(fontSize: 24)),
          _buildTimeSelectionContainer(),
          _buildButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSelectDateTimeButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: ElevatedButton(
        onPressed: () => _selectDateTime(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textStyle: const TextStyle(fontSize: 20),
        ),
        child: const Text(
          'Select date and time of arrival',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTimeSelectionContainer() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Time (Hours)',
              style: TextStyle(fontSize: 22),
            ),
            CountController(
              count: _selectedHours,
              onChanged: (newCount) {
                setState(() {
                  _selectedHours = newCount;
                });
              },
            ),
            const SizedBox(height: 10),

            Text(
              'Total Amount: ₹${_selectedHours * 30}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapsPage()),
            );
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehicleDetailsPage(amountToPay: _selectedHours*30,)),
            );
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
    );
  }
}
