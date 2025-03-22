// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'admin_page.dart';
// import 'main_page.dart';
// import 'signup_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   TextEditingController rollNumberController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   void login(BuildContext context) async {
//     String rollno = rollNumberController.text.trim();
//     String password = passwordController.text.trim();

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: "$rollno@nitrkl.ac.in",
//         password: password,
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         await user.reload();
//         user = _auth.currentUser;

//         if (user!.emailVerified) {
//           DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

//           if (userDoc.exists) {
//             String role = userDoc['role'];
//             bool isVerified = userDoc['isVerified'];
//             String requestStatus = userDoc['requestStatus'];

//             if (role == 'secretary' || role == 'president' || role == 'vice president' || role == 'lead' ) {
//               if (isVerified) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => AdminPage()),
//                 );
//               } else {
//                 showMessage("Account not verified. Contact the admin.");
//               }
//             } else if (role == 'member') {
//               if (!isVerified) {
//                 showMessage("Request pending. Contact admin to accept your request.");
//               } else if (requestStatus == 'accepted') {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => MainPage()),
//                 );
//               } else {
//                 showMessage("Request not yet accepted. Contact the admin.");
//               }
//             } else {
//               showMessage("Unauthorized role.");
//             }
//           } else {
//             showMessage("User data not found.");
//           }
//         } else {
//           showMessage("Please verify your email before logging in.");
//           await _auth.signOut();
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       showMessage("Error: ${e.message}");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Login',
//                 style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 40.0),
//               TextField(
//                 controller: rollNumberController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Roll Number',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
//                 ),
//                 keyboardType: TextInputType.text,
//               ),
//               const SizedBox(height: 20.0),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Password',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 30.0),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  SignUpPage()));
//                 },
//                 child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//               const SizedBox(height: 30.0),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () => login(context),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                       child: const Text('Login', style: TextStyle(fontSize: 18.0)),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyborg/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_page.dart';
import 'main_page.dart';
import 'signup_page.dart';

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

  void login(BuildContext context) async {
    String rollno = rollNumberController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$rollno@nitrkl.ac.in",
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.reload();
        user = _auth.currentUser;

        if (user!.emailVerified) {
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String role = userDoc['role'];
            bool isVerified = userDoc['isVerified'];
            String requestStatus = userDoc['requestStatus'];

            if (role == 'secretary' ||
                role == 'president' ||
                role == 'vice president' ||
                role == 'lead') {
              if (isVerified) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                showMessage(
                    "Your account is not verified. Please contact the admin.");
              }
            } else if (role == 'member') {
              if (!isVerified) {
                showMessage(
                    "Your request is pending. Contact the admin for approval.");
              } else if (requestStatus == 'accepted') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                showMessage(
                    "Your request has not been accepted yet. Contact the admin.");
              }
            } else {
              showMessage(
                  "Unauthorized role detected. Please contact support.");
            }
          } else {
            showMessage("User data not found in the system.");
          }
        } else {
          showMessage("Please verify your email before logging in.");
          await _auth.signOut();
        }
      }
    } on FirebaseAuthException catch (e) {
      showMessage("Error: ${e.message}");
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 40.0),
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
                const SizedBox(height: 20.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : () => login(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.0),
                            )
                          : const Text('Login',
                              style: TextStyle(fontSize: 18.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to the login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Main Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
