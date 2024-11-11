import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  Map<String, dynamic>? userData; // User data

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = doc.data() as Map<String, dynamic>?;

        // Decrypt the full name (assuming you have a decrypt function)
        if (userData != null) {
          userData!['fullName'] = decrypt(userData!['fullName']);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load user data.'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String decrypt(String encryptedData) {
    // Your decryption logic here
    return encryptedData; // Modify this line to implement actual decryption
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keep background consistent with login
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Flat AppBar, no shadow
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text('No user data found.'))
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // Add spacing for better UI flow
            _buildProfileText('Full Name', userData!['fullName']),
            _buildProfileText('Email Address', userData!['email']),
            _buildProfileText(
                'Date of Birth', userData!['dateOfBirth']),
            _buildProfileText(
                'Time of Birth', userData!['timeOfBirth']),
            _buildProfileText(
                'Location of Birth', userData!['locationOfBirth']),
            _buildProfileText('Blood Group', userData!['bloodGroup']),
            _buildProfileText('Sex', userData!['sex']),
            _buildProfileText('Height', '${userData!['height']} cm'),
            _buildProfileText('Ethnicity', userData!['ethnicity']),
            _buildProfileText('Eye Colour', userData!['eyeColor']),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set profile as the selected page
        onTap: (index) async {
          if (index == 3) {
            // Confirm logout before logging out
            bool? confirmLogout = await _showLogoutDialog(context);
            if (confirmLogout == true) {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login'); // Redirect to login page
            }
          } else {
            // Navigate based on the selected index
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/profile');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/settings');
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  // Helper to build profile text consistently
  Widget _buildProfileText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  // Method to show logout confirmation dialog
  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
