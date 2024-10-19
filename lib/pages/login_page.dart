// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyborg/pages/main_page.dart';
import 'package:cyborg/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController rollNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to log in using Firebase Authentication
  void login(BuildContext context) async {
    String rollno = rollNumberController.text.trim();
    String password = passwordController.text.trim();
    bool verified = false;

    setState(() {
      isLoading = true;
    });

    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$rollno@nitrkl.ac.in",
        password: password,
      );
      User? user = userCredential.user;

      await _firestore.collection('users').doc(user?.uid).get().then((value) {
        if (value.exists) {
          verified = value.data()!['verified'];
          if (value.data()!['verified'] == false) {
            showMessage("You are not verified yet.");
            _auth.signOut();
          } else {
            showMessage("Login successful");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        }
      });

      // Check if email is verified
    } on FirebaseAuthException catch (e) {
      showMessage("Error: ${e.message}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to display messages
  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40.0),

                // Roll Number Field
                TextField(
                  controller: rollNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter Roll Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.0),

                // Password Field
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 30.0),

                RichText(
                    text: TextSpan(children: [
                  const TextSpan(text: 'Don\'t have an account? '),
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                  ),
                ])),
                const SizedBox(height: 30.0),

                // Login Button
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => login(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
