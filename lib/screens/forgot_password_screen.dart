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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Account Recovery', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Heading Text
                Text(
                  'Recover Your Account',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Full Name Field
                _buildTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                ),
                SizedBox(height: 16.0),

                // Date of Birth Field
                _buildTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth (YYYY-MM-DD)',
                ),
                SizedBox(height: 16.0),

                // Security Answer 1 Field
                _buildTextField(
                  controller: _securityAnswer1,
                  labelText: 'Childhood Best Friend\'s Name',
                ),
                SizedBox(height: 16.0),

                // Security Answer 2 Field
                _buildTextField(
                  controller: _securityAnswer2,
                  labelText: 'Childhood Pet\'s Name',
                ),
                SizedBox(height: 20),

                // Recover Button
                ElevatedButton(
                  onPressed: _recoverAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Recover Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      ),
      validator: (value) => value!.isEmpty ? 'Enter your answer' : null,
      style: TextStyle(color: Colors.black87),
    );
  }
}
