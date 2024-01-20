import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'signin.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SignUpWidget(),
        ),
      ),
    );
  }
}

class SignUpWidget extends StatelessWidget {
   const SignUpWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/img.jpg',
            width: 318.0,
            height: 150.0,
          ),
          const Text(
            'Welcome',
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'bangers',
            ),
          ),
          const Text(
            'SignUp to start your new journey',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 10.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'UserName',
              counterText: '',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
            maxLength: 15,
          ),
          const SizedBox(height: 10.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Phone No',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10.0),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
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
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(5.0),
            ),
            child: const Text(
              'Already have an account? LogIn',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
