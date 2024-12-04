import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyborg/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  String selectedSubsystem = "Robotics";
  String selectedYear = "2nd";

  bool isLoading = false;

  final List<String> subsystems = [
    "Robotics",
    "Electronics",
    "Mechanical",
    "Web and Automation",
    "Creative and Management",
  ];

  final List<String> years = ["2nd", "3rd", "4th", "5th"];

  Future<bool> signUp() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String rollNumber = rollNumberController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String role = roleController.text.trim();

    if (password != confirmPassword) {
      showMessage("Passwords do not match!");
      return false;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: "$rollNumber@nitrkl.ac.in",
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store user information in the 'requests' collection
        await _firestore.collection('requests').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'rollNumber': rollNumber,
          'subsystem': selectedSubsystem,
          'year': selectedYear,
          'role': role,
          'uid': user.uid,
          'verified': false,
          'requestStatus':'pending'
        });

        // Send email verification
        await user.sendEmailVerification();

        showMessage("Verification email sent. Please verify your account.");
        await _auth.signOut();
      }

      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "Sign Up Failed");
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40.0),

                // Name Field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Phone Number Field
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number (+91)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20.0),

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
                ),
                const SizedBox(height: 20.0),

                // Subsystem Dropdown
                DropdownButtonFormField(
                  value: selectedSubsystem,
                  items: subsystems
                      .map((subsystem) => DropdownMenuItem(
                            value: subsystem,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(subsystem),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubsystem = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                const SizedBox(height: 20.0),

                // Year Dropdown
                DropdownButtonFormField(
                  value: selectedYear,
                  items: years
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(year),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                const SizedBox(height: 20.0),

                // Role Field
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Role (e.g., Secretary, President, Member)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

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
                const SizedBox(height: 20.0),

                // Confirm Password Field
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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

                // Login Link
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                    ),
                  ]),
                ),
                const SizedBox(height: 30.0),

                // Sign Up Button
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18.0),
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
