import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cyborg/pages/login_page.dart'; // Ensure this points to your LoginPage

class AdminPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Log out the user
              await FirebaseAuth.instance.signOut();
              // Navigate back to the login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('requests')
            .where('requestStatus', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              return ListTile(
                title: Text(request['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subsystem: ${request['subsystem']}'),
                    Text('Role: ${request['role']}'),
                    Text('Year: ${request['year']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        try {
                          // Move request data to the 'users' collection
                          await _firestore.collection('users').doc(request.id).set({
                            'name': request['name'],
                            'subsystem': request['subsystem'],
                            'role': request['role'],
                            'year': request['year'],
                            'isVerified': true,
                            'requestStatus':'accepted' // Example: add fields as needed
                          });

                          // Remove the request from the 'requests' collection
                          await _firestore.collection('requests').doc(request.id).delete();

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request accepted successfully!')),
                          );
                        } catch (e) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        try {
                          // Update request status to 'rejected'
                          await _firestore.collection('requests').doc(request.id).update({
                            'requestStatus': 'rejected',
                          });

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request rejected!')),
                          );
                        } catch (e) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


