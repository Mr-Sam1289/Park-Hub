
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'splashscreen.dart';
import 'signup.dart';
import 'signin.dart';
import 'HomePage.dart';
import 'account_screen.dart';
import 'dateandtime.dart';
import 'MapsPage.dart';
import 'payment_page.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set the home property to SplashScreen
      routes: {
        'signup': (context) => const SignUp(),
        'signin': (context) =>  const SignIn(),
        'HomePage': (context) => const HomePage(),
        'AccountScreen': (context) => const AccountScreen(),
        'ParkingApp': (context) => const ParkingApp(),// Add this line for ParkingApp screen
        'MapsPage': (context) => const MapsPage(),
        'payment_page': (context) => const PaymentScreen(),
      },
    );
  }
}