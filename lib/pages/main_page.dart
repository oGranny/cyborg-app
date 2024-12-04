import 'package:flutter/material.dart';
import 'package:cyborg/pages/login_page.dart'; // Ensure this import points to your LoginPage

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


