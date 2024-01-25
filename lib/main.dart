import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartparkin1/mybookings.dart';
import 'package:smartparkin1/payment_page.dart';
import 'package:smartparkin1/profile_page.dart';
import 'package:smartparkin1/slot.dart';
import 'package:smartparkin1/vehicle_details_page.dart';
import 'firebase_options.dart';
import 'invoice.dart';
import 'splashscreen.dart';
import 'signup.dart';
import 'signin.dart';
import 'HomePage.dart';
import 'settings_page.dart';
import 'dateandtime.dart';
import 'MapsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart parking',
      home: const AuthWrapper(), // Change the home property
      routes: {
        'signup': (context) => const SignUpWidget(),
        'signin': (context) => const SignInPage(),
        'homepage': (context) => const HomePage(),
        'settings_page': (context) => const SettingsPage(),
        'mybookings': (context) => const MyBookingsPage(),
        'dateandtime': (context) => const DateAndTime(lotName:'',lotId: '',),
        'MapsPage': (context) => const MapsPage(),
        'profile_page': (context) => const ProfilePage(),
        'vehicle_details_page': (context) => VehicleDetailsPage(
          amountToPass: 0.0,
          lotName: '',
          reserved: DateTime(2004),
          hours: 0,
          lotId: '',
        ),
        'slot': (context) => SelectSlotPage(
          amountToPass:0.0,
          selectedVehicleType: '',
          selectedVehicleNumber:'',
          reserved: DateTime(2004),
          lotName:'',
          hours: 0,
          lotId: '',
        ),
        'payment_page': (context) => PaymentScreen(
          amountToPay: 0.0,
          selectedVehicleType:'',
          selectedVehicleNumber: '',
          hours: 0,
          reserved:DateTime(2004),
          lotName:'',
          slot: '',
          lotId: '',
        ),
        'invoice': (context) => InvoicePage(
          lot: '',
          slot: '',
          reservedHours: 0,
          reservedDate: DateTime.now().add(const Duration(days: 1)),
          totalAmount: 0.0,
          vehicleType: '',
          vehicleNumber: '',
          lotId: '',
        ),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUser(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            // User is authenticated, navigate to HomePage
            return const HomePage();
          } else {
            // User is not authenticated, navigate to SplashScreen
            return const SplashScreen();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the authentication check, show SplashScreen as a loading indicator
          return const SplashScreen();
        } else {
          // Handle other possible states (e.g., error)
          // Replace with your error screen widget
          return const ErrorScreen();
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('An error occurred.'),
      ),
    );
  }
}
