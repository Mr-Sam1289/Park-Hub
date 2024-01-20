import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the HomePage
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:SingleChildScrollView(
        child: YourWidget(),
    )
    );
  }
}

class YourWidget extends StatelessWidget {
  const YourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/img.jpg',
            height: 227.0,
          ),
          const Text(
            'Hello there, Welcome Back',
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'bangers',
            ),
          ),
          const Text(
            'Sign In to continue',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'antic',
            ),
          ),
          const SizedBox(height: 20.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
            child: const Text(
              'Forget Password',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
            child: const Text(
              'GO',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(5.0),
            ),
            child: const Text(
              'New User? SIGN UP',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'antic',
              ),
            ),
          ),
        ],
      ),
    );
  }
}