import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; 

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Welcome to the Main Page!',
        style: TextStyle(fontSize: 24),
      ),
    ),
    FetchDataScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'Keys',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

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
