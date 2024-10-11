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

  // User data
  Map<String, dynamic>? userData;

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

        // Assuming you have a decrypt function defined
        if (userData != null) {
          userData!['fullName'] = decrypt(userData!['fullName']); // Decrypt the full name
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load user data.')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmail() async {
    String newEmail = userData?['email'] ?? '';
    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email cannot be empty.')));
      return;
    }
    try {
      await user!.updateEmail(newEmail);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'email': newEmail});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email updated successfully.')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: ${e.message}')));
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
        content: Text('Are you sure you want to unsubscribe? This will delete your data permanently.'),
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
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
        await user!.delete();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unsubscribed successfully.')));
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to unsubscribe: $e')));
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
      backgroundColor: Color(0xFFF1F5FB), // Light background color
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout)),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text('No user data found.'))
          : SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            _buildProfileText('Full Name:', userData!['fullName']),
            SizedBox(height: 10),

            // Email Address
            _buildProfileText('Email Address:', userData!['email']),
            SizedBox(height: 20),

            // Other user details
            _buildProfileText('Date of Birth:', userData!['dateOfBirth']),
            _buildProfileText('Time of Birth:', userData!['timeOfBirth']),
            _buildProfileText('Location of Birth:', userData!['locationOfBirth']),
            _buildProfileText('Blood Group:', userData!['bloodGroup']),
            _buildProfileText('Sex:', userData!['sex']),
            _buildProfileText('Height:', '${userData!['height']} cm'),
            _buildProfileText('Ethnicity:', userData!['ethnicity']),
            _buildProfileText('Eye Colour:', userData!['eyeColor']),
            SizedBox(height: 30),

            // Button Row for Change Password and Unsubscribe
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Change Password Button
                _buildButton('Change Password', Colors.blue, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                }),

                // Unsubscribe Button
                _buildButton('Unsubscribe', Colors.red, _unsubscribe),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build profile text widgets
  Widget _buildProfileText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build buttons
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
