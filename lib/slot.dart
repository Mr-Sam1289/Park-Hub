import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartparkin1/payment_page.dart';
import 'package:smartparkin1/vehicle_details_page.dart';

class SelectSlotPage extends StatefulWidget {
  final double amountToPay;
  final String selectedVehicleType;

  const SelectSlotPage({super.key, required this.selectedVehicleType,required this.amountToPay});

  @override
  SelectSlotPageState createState() => SelectSlotPageState();
}

class SelectSlotPageState extends State<SelectSlotPage> {
  String selectedSlot = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehicleDetailsPage(amountToPay: 0.0,),
            ),
          );
        },
        icon: const Icon(Ionicons.chevron_back_outline),
      ),
      leadingWidth: 80,
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
        "Select Slot",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/road.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildSlotGrid(),
          ),
          const SizedBox(height: 10),
          _buildProceedButton(),
        ],
      ),
    );
  }

  Widget _buildSlotGrid() {
    return GridView.builder(
      itemCount: 15,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 3;
        int col = index % 3;

        if (col == 0 || col == 2) {
          int slotNumber = (row * 2) + (col == 0 ? 1 : 2);

          return _buildSlotContainer(slotNumber);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSlotContainer(int slotNumber) {
    return GestureDetector(
      onTap: () {
        _handleSlotSelection(slotNumber);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: selectedSlot == 'A-$slotNumber'
            ? _buildVehicleImage() // Dynamically load vehicle image
            : const SizedBox(),
      ),
    );
  }

  void _handleSlotSelection(int slotNumber) {
    setState(() {
      selectedSlot = 'A-$slotNumber';
    });
  }

  Widget _buildVehicleImage() {
    // Map vehicle types to corresponding image assets
    final Map<String, String> vehicleTypeImages = {
      'Car': 'assets/images/car1.jpg',
      'Motorcycle': 'assets/images/motorcycle.jpg',
      'Truck': 'assets/images/truck.jpg',
      'Other': 'assets/images/other.jpg',
    };

    // Get the selected vehicle type
    final selectedVehicleType = widget.selectedVehicleType;

    // Check if selectedVehicleType is not null and exists in the map
    // ignore: unnecessary_null_comparison
    if (selectedVehicleType != null && vehicleTypeImages.containsKey(selectedVehicleType)) {
      // Use the selected vehicle type to load the corresponding image
      return Image.asset(vehicleTypeImages[selectedVehicleType]!);
    } else {
      // Handle the case where selectedVehicleType is null or not found in the map
      return const SizedBox();
    }
  }


  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedSlot.isNotEmpty
            ? () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaymentScreen()),
          );
        }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          'Proceed with spot ($selectedSlot)',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
