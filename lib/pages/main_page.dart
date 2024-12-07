// import 'package:flutter/material.dart';
// import 'package:cyborg/pages/login_page.dart'; // Ensure this import points to your LoginPage

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main Page'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Navigate back to the login page
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: const Center(
//         child: Text(
//           'Welcome to the Main Page! Panakj',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cyborg/pages/login_page.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   bool _hasRequested = false;
//   Color _buttonColor = const Color.fromRGBO(89, 189, 255, 1);
//   String _grantedName = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentKeyHolder(); // Fetch the current key holder on load
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main Page'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Sign out and navigate to login page
//               FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (user != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Logged in as: ${user.displayName ?? 'Anonymous'}',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           if (_grantedName.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Current Key Holder: $_grantedName',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           Expanded(
//             child: FutureBuilder<List<QueryDocumentSnapshot>>(
//               future: fetchData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Error fetching data: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No data available'));
//                 }
//                 return ListView(
//                   children: snapshot.data!.map((document) {
//                     final data = document.data() as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text(data['Name'] ?? 'No Name'),
//                       subtitle: Text('Roll No: ${data['RollNo'] ?? 'N/A'}'),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _handleIHaveTheKeyPress,
//         label: Text(_hasRequested ? 'Requested' : 'I have the key'),
//         icon: const Icon(Icons.vpn_key),
//         backgroundColor: _buttonColor,
//       ),
//     );
//   }

//   /// Fetch all data from the "keys" collection
//   Future<List<QueryDocumentSnapshot>> fetchData() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('keys').get();
//       return querySnapshot.docs;
//     } catch (error) {
//       throw Exception('Failed to fetch data: $error');
//     }
//   }

//   /// Handle "I have the key" button press
//   void _handleIHaveTheKeyPress() async {
//     setState(() {
//       _hasRequested = true;
//       _buttonColor = Colors.green;
//     });

//     try {
//       await FirebaseFirestore.instance.collection('requests').add({
//         'status': 'requested',
//         'timestamp': FieldValue.serverTimestamp(),
//         'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
//       });
//     } catch (e) {
//       print("Error storing data: $e");
//     }
//   }

//   /// Fetch the current key holder's name from the "requests" collection
//   Future<void> _fetchCurrentKeyHolder() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('requests')
//           .where('status', isEqualTo: 'granted')
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         setState(() {
//           _grantedName = querySnapshot.docs.first['name'];
//         });
//       }
//     } catch (error) {
//       print("Error fetching current key holder: $error");
//     }
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cyborg/pages/login_page.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   String _currentKeyHolder = 'Ritul Raj'; // Default key holder
//   bool _hasRequested = false;
//   Color _buttonColor = const Color.fromRGBO(89, 189, 255, 1);

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentKeyHolder(); // Fetch current key holder on load
//     _initializeDefaultKeyHolder(); // Ensure "Ritul Raj" is the initial key holder
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main Page'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Sign out and navigate to login page
//               FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (user != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Logged in as: ${user.displayName ?? 'Anonymous'}',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Current Key Holder: $_currentKeyHolder',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           if (user != null && user.displayName == _currentKeyHolder)
//             Expanded(
//               child: FutureBuilder<List<QueryDocumentSnapshot>>(
//                 future: _fetchRequests(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(
//                         child: Text('Error fetching requests: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No requests yet.'));
//                   }
//                   return ListView(
//                     children: snapshot.data!.map((document) {
//                       final data = document.data() as Map<String, dynamic>;
//                       return ListTile(
//                         title: Text(data['name'] ?? 'No Name'),
//                         subtitle: Text('Status: ${data['status']}'),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             _grantAccess(document.id, data['name'] ?? 'Unknown');
//                           },
//                           child: const Text('Grant Access'),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           if (user == null || user.displayName != _currentKeyHolder)
//             const Center(
//               child: Text(
//                 'You are not the current key holder. Requests cannot be viewed.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ),
//       ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _handleRequestKeyPress,
//         label: Text(_hasRequested ? 'Requested' : 'I have the key'),
//         icon: const Icon(Icons.vpn_key),
//         backgroundColor: _buttonColor,
//       ),
//     );
//   }

//   /// Initialize the default key holder as "Ritul Raj" in Firestore
//   Future<void> _initializeDefaultKeyHolder() async {
//     try {
//       DocumentSnapshot snapshot =
//           await FirebaseFirestore.instance.collection('currentKey').doc('key').get();

//       if (!snapshot.exists) {
//         await FirebaseFirestore.instance.collection('currentKey').doc('key').set({
//           'name': 'Ritul Raj',
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//       }
//     } catch (e) {
//       print("Error initializing default key holder: $e");
//     }
//   }

//   /// Fetch the current key holder from Firestore
//   Future<void> _fetchCurrentKeyHolder() async {
//     try {
//       DocumentSnapshot snapshot =
//           await FirebaseFirestore.instance.collection('currentKey').doc('key').get();

//       if (snapshot.exists) {
//         setState(() {
//           _currentKeyHolder = snapshot['name'] ?? 'Unknown';
//         });
//       }
//     } catch (e) {
//       print("Error fetching current key holder: $e");
//     }
//   }

//   /// Handle "I have the key" button press
//   void _handleRequestKeyPress() async {
//     setState(() {
//       _hasRequested = true;
//       _buttonColor = Colors.green;
//     });

//     try {
//       await FirebaseFirestore.instance.collection('requests').add({
//         'status': 'requested',
//         'timestamp': FieldValue.serverTimestamp(),
//         'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
//       });
//     } catch (e) {
//       print("Error storing request: $e");
//     }
//   }

//   /// Fetch all pending requests from Firestore
//   Future<List<QueryDocumentSnapshot>> _fetchRequests() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('requests').get();
//       return querySnapshot.docs;
//     } catch (error) {
//       throw Exception('Failed to fetch requests: $error');
//     }
//   }

//   /// Grant access to a specific user and update Firestore
//   Future<void> _grantAccess(String requestId, String name) async {
//     try {
//       // Update the key holder in the "currentKey" collection
//       await FirebaseFirestore.instance.collection('currentKey').doc('key').set({
//         'name': name,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Update the request's status to "granted"
//       await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
//         'status': 'granted',
//       });

//       // Update the UI
//       setState(() {
//         _currentKeyHolder = name;
//       });
//     } catch (e) {
//       print("Error granting access: $e");
//     }
//   }
// }













import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FetchDataScreen extends StatefulWidget {
  const FetchDataScreen({super.key});

  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  bool _hasRequested = false;
  String _grantedName = '';
  String _grantedUserId = '';
  String _currentUserId = '';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      _checkIfAdmin();
      _fetchCurrentKeyHolder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keys Management'),
        backgroundColor: const Color.fromRGBO(89, 189, 255, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Logged in as: ${user.displayName ?? 'Anonymous'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          if (_grantedName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Current Key Holder: $_grantedName',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: _fetchRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching data: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No requests available'));
                }

                return ListView(
                  children: snapshot.data!.map((document) {
                    final data = document.data() as Map<String, dynamic>;
                    final isCurrentUser = data['userId'] == _currentUserId;

                    if (!_isAdmin &&
                        _grantedUserId != _currentUserId &&
                        !isCurrentUser) {
                      return Container(); // Skip if not admin or key holder
                    }

                    return ListTile(
                      title: Text(data['name'] ?? 'No Name'),
                      subtitle: Text(
                          'Status: ${data['status'] ?? 'Pending'} | Timestamp: ${data['timestamp'] ?? 'N/A'}'),
                      trailing: _isAdmin && data['status'] == 'requested'
                          ? ElevatedButton(
                              onPressed: () => _grantAccess(document.id, data['name'], data['userId']),
                              child: const Text('Grant Access'),
                            )
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          if (!_isAdmin)
            FloatingActionButton.extended(
              onPressed: _handleIHaveTheKeyPress,
              label: Text(_hasRequested ? 'Requested' : 'I have the key'),
              icon: const Icon(Icons.vpn_key),
              backgroundColor: _hasRequested ? Colors.green : Colors.blue,
            ),
        ],
      ),
    );
  }

  Future<void> _checkIfAdmin() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    if (currentUserEmail == 'ritul.raj@example.com') { // Replace with actual admin email
      setState(() {
        _isAdmin = true;
      });
    }
  }

  Future<void> _fetchCurrentKeyHolder() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('status', isEqualTo: 'granted')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>? ?? {};
        setState(() {
          _grantedName = data['name'] ?? 'Unknown';
          _grantedUserId = data['userId'] ?? '';
        });
      }
    } catch (error) {
      print("Error fetching current key holder: $error");
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchRequests() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('requests').get();
      return querySnapshot.docs;
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  Future<void> _grantAccess(String requestId, String name, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'status': 'granted',
        'timestamp': FieldValue.serverTimestamp(),
      });

      final previousRequests = await FirebaseFirestore.instance
          .collection('requests')
          .where('status', isEqualTo: 'granted')
          .get();

      for (var doc in previousRequests.docs) {
        if (doc.id != requestId) {
          await FirebaseFirestore.instance.collection('requests').doc(doc.id).update({
            'status': 'revoked',
          });
        }
      }

      setState(() {
        _grantedName = name;
        _grantedUserId = userId;
      });
    } catch (error) {
      print("Error granting access: $error");
    }
  }

  void _handleIHaveTheKeyPress() async {
    setState(() {
      _hasRequested = true;
    });

    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'status': 'requested',
        'timestamp': FieldValue.serverTimestamp(),
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'userId': _currentUserId,
      });
    } catch (e) {
      print("Error submitting key request: $e");
    }
  }
}
