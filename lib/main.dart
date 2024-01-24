import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'splashscreen.dart';
import 'signup.dart';
import 'signin.dart';
import 'HomePage.dart';
import 'settings_page.dart';
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
      home: const AuthWrapper(), // Change the home property
      routes: {
        'signup': (context) => const SignUpWidget(),
        'signin': (context) => const SignInPage(),
        'HomePage': (context) => const HomePage(),
        'AccountScreen': (context) => const AccountScreen(),
        'ParkingApp': (context) => const ParkingApp(),
        'MapsPage': (context) => const MapsPage(),
        'payment_page': (context) => const PaymentScreen(),
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
