// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:smartparkin1/signin.dart';
import 'package:logger/logger.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final Logger logger = Logger();
  bool _isPasswordVisible = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildLogo(),
                _buildHeaderText(),
                _buildNameFields(),
                const SizedBox(height: 10),
                _buildUserNameField(),
                const SizedBox(height: 10),
                _buildEmailField(),
                const SizedBox(height: 10),
                _buildPhoneNumberField(),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildConfirmPasswordField(),
                const SizedBox(height: 10),
                _buildSignUpButton(),
                const SizedBox(height: 10),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section 1: UI Components

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/img.jpg',
      width: 318.0,
      height: 150.0,
    );
  }

  Widget _buildHeaderText() {
    return const Column(
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            fontSize: 40.0,
            fontFamily: 'bangers',
          ),
        ),
        Text(
          "Let's create your account",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField(
            controller: _firstNameController,
            labelText: 'First Name',
            prefixIcon: Icons.account_circle_outlined,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: _buildTextFormField(
            controller: _lastNameController,
            labelText: 'Last Name',
            prefixIcon: Icons.account_circle_outlined,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return _buildTextFormField(
      controller: _userNameController,
      labelText: 'User Name',
      prefixIcon: Icons.account_circle,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a user name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextFormField(
      controller: _emailController,
      labelText: 'Email',
      prefixIcon: Icons.alternate_email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return _buildTextFormField(
      controller: _phoneNumberController,
      labelText: 'Mobile Number',
      prefixIcon: Icons.mobile_friendly,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        else if (value.length < 10 ) {
          return ' Please enter valid mobile number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildPasswordTextFormField(
      controller: _passwordController,
      labelText: 'Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildPasswordTextFormField(
      controller: _confirmPasswordController,
      labelText: 'Confirm Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        } else if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        _signUp(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
      ),
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(5.0),
      ),
      child: const Text(
        'Already have an account? LOGIN',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  // Section 2: Helper Methods

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
      ),
      style: const TextStyle(fontSize: 20.0),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  Widget _buildPasswordTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          child: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 20.0),
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }

  // Section 3: Firebase Authentication and Database Operations

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user?.emailVerified ?? false) {
      logger.i('Email is verified');
    } else {
      logger.i('Email is not verified');
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.sendEmailVerification();

    logger.i('Verification email sent to ${user?.email}');
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() == _confirmPasswordController.text.trim();
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        if (passwordConfirmed()) {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          await addUserDetails(
            userCredential.user?.uid ?? '',
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _userNameController.text.trim(),
            _emailController.text.trim(),
            _phoneNumberController.text.trim(),
            _passwordController.text.trim(),
          );

          // Send email verification
          await userCredential.user?.sendEmailVerification();

          // Display a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification email sent.'),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during sign-up.')),
      );
    }
  }

  // Section 4: Authentication State Changes

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.emailVerified ?? false) {
        // If email is verified, navigate to SignInPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  // Section 5: Database Operations

  Future<void> addUserDetails(String userId, String firstName, String lastName, String userName, String email, dynamic mobileNumber, String password) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
    });
  }
}
