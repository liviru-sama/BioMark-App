import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'change_password.dart'; // Import the Change Password screen

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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _unsubscribe() async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Unsubscribe'),
        content: Text(
            'Are you sure you want to unsubscribe? This will delete your data permanently.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Unsubscribe')),
        ],
      ),
    );
    if (confirm) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .delete();
        await user!.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unsubscribed successfully.'),
        ));
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to unsubscribe: $e'),
        ));
      }
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
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
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
                      Column(
                        children: [
                          _buildButtonRow(), // Reusable button row for consistent UI
                          SizedBox(
                              height:
                                  20), // Space between buttons and page bottom
                        ],
                      ),
                    ],
                  ),
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

  // Helper to build buttons
  Widget _buildButton(String label, Color textColor, Color backgroundColor,
      VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // Reusable button row to keep layout clean and consistent
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildButton(
            'Change Details',
            Colors.white, // Text color black
            Colors.black, // Background color white
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            },
          ),
        ),
        SizedBox(width: 10), // Space between the buttons
        Expanded(
          child: _buildButton(
            'Unsubscribe',
            Colors.white, // Text color white
            Colors.black, // Background color black
            _unsubscribe,
          ),
        ),
      ],
    );
    SizedBox(height: 20);
  }
}
