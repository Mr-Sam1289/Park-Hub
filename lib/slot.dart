import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartparkin1/payment_page.dart';
class SelectSlotPage extends StatefulWidget {
  const SelectSlotPage({super.key});
  @override
  SelectSlotPageState createState() => SelectSlotPageState();
}

class SelectSlotPageState extends State<SelectSlotPage> {
  String selectedSlot = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        title: const Text('Select Slot'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/road.jpg'), // Change this to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: 15,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  // Calculate row and column
                  int row = index ~/ 3;
                  int col = index % 3;

                  // Only allow clicks on the 1st and 3rd columns
                  if (col == 0 || col == 2) {
                    // Calculate slot number for the 1st and 3rd columns within the same row
                    int slotNumber = (row * 2) + (col == 0 ? 1 : 2);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSlot = 'A-$slotNumber';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: selectedSlot == 'A-$slotNumber'
                            ? Image.asset('assets/images/car1.jpg')
                            : const SizedBox(), // Use SizedBox() instead of null
                      ),
                    );
                  } else {
                    // Empty container for the 2nd column
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity, // Set the width to occupy the entire screen width
              child: ElevatedButton(
                onPressed: selectedSlot.isNotEmpty
                    ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentScreen()), // Use HomePage()
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
                child: Text('Proceed with spot ($selectedSlot)',style: const TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}