// lib/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/encryption_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _securityAnswer1 = TextEditingController();
  final TextEditingController _securityAnswer2 = TextEditingController();

  bool _isLoading = false;

  // Initialize EncryptionHelper
  final encryptionHelper = EncryptionHelper(
      encrypt.Key.fromUtf8('32_characters_long_key_here!'),
      encrypt.IV.fromLength(16)
  );

  Future<void> _recoverAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Query users collection based on full name and date of birth
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users')
            .where('fullName', isEqualTo: _fullNameController.text.trim())
            .where('dateOfBirth', isEqualTo: _dobController.text.trim())
            .get();

        if (userSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No matching user found.')));
          return;
        }

        // Assuming fullName and dob uniquely identify a user
        String userId = userSnapshot.docs.first.id;

        // Retrieve security data
        DocumentSnapshot securityDoc = await FirebaseFirestore.instance.collection('security').doc(userId).get();
        if (!securityDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Security data not found.')));
          return;
        }

        Map<String, dynamic> securityData = securityDoc.data() as Map<String, dynamic>;

        // Decrypt and verify security answers
        String decryptedAnswer1 = encryptionHelper.decrypt(securityData['childhoodBestFriend']);
        String decryptedAnswer2 = encryptionHelper.decrypt(securityData['childhoodPet']);

        if (_securityAnswer1.text.trim() == decryptedAnswer1 &&
            _securityAnswer2.text.trim() == decryptedAnswer2) {
          // Send password reset email
          String email = userSnapshot.docs.first['email'];
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent.')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect security answers.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _securityAnswer1.dispose();
    _securityAnswer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Recovery'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) :
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter your full name' : null,
              ),
              SizedBox(height: 10),
              // Date of Birth
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Enter your date of birth' : null,
              ),
              SizedBox(height: 10),
              // Security Answer 1
              TextFormField(
                controller: _securityAnswer1,
                decoration: InputDecoration(labelText: 'Childhood Best Friend\'s Name'),
                validator: (value) => value!.isEmpty ? 'Enter your answer' : null,
              ),
              SizedBox(height: 10),
              // Security Answer 2
              TextFormField(
                controller: _securityAnswer2,
                decoration: InputDecoration(labelText: 'Childhood Pet\'s Name'),
                validator: (value) => value!.isEmpty ? 'Enter your answer' : null,
              ),
              SizedBox(height: 20),
              // Recover Button
              ElevatedButton(
                onPressed: _recoverAccount,
                child: Text('Recover Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
