import 'package:flutter/material.dart';
import 'package:smartparkin1/MapsPage.dart';
import 'settings_page.dart';
import 'mybookings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container with Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200.0,
              child: Image.asset(
                'assets/images/homebg2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // White Container with Rounded Edges
          Positioned(
            top: 200.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: Wrap(
                        spacing: 20,
                        children: [
                          // Removed payment details, guidelines, any changes in your details?, and any help? buttons
                        ],
                      ),
                    ),
                    buildGestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MapsPage()),
                        );
                      },
                      imageAsset: 'assets/images/ReserveParkingSpace.jpg',
                      title: 'Reserve a parking space',
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                    ),
                    buildGestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MyBookingsPage()),
                        );
                      },
                      imageAsset: 'assets/images/MyBookings.png',
                      title: 'My Bookings',
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                    ),
                    buildGestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage()),
                        );
                      },
                      imageAsset: 'assets/images/settingsIcon.png',
                      title: 'Settings',
                      trailingIcon: Icons.arrow_forward_ios_sharp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector({
    required VoidCallback onTap,
    required String imageAsset,
    required String title,
    required IconData trailingIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              width: 100,
              height: 100.0,
            ),
            ListTile(
              title: Text(title),
              trailing: Icon(trailingIcon),
            ),
          ],
        ),
      ),
    );
  }
}
