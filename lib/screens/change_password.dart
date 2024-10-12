import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  Future<void> _updateEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    String newEmail = _newEmailController.text;
    String currentPassword = _currentPasswordController.text;

    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a new email.'),
      ));
      return;
    }

    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the email
      await user.updateEmail(newEmail);

      // Send email verification
      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email updated successfully. Please verify your new email.'),
      ));
      Navigator.pop(context); // Go back to profile screen
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update email: ${e.message}'),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatePassword() async {
    User? user = FirebaseAuth.instance.currentUser;

    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New password must be at least 6 characters.'),
      ));
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New passwords do not match.'),
      ));
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully.'),
      ));
      Navigator.pop(context); // Go back to profile screen
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update password: ${e.message}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background color
      appBar: AppBar(
        title: Text('Change Details'),
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Section - Update Email
            Text(
              'Update Your Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildEmailInput('New Email Address', _newEmailController),
            SizedBox(height: 20),
            _buildPasswordInput('Current Password (Required for Email Update)', _currentPasswordController),
            SizedBox(height: 20),
            Center(
              child: _buildActionButton('Update Email', _updateEmail),
            ),
            SizedBox(height: 30),

            // Second Section - Update Password
            Text(
              'Update Your Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildPasswordInput('Current Password', _currentPasswordController),
            SizedBox(height: 20),
            _buildPasswordInput('New Password', _newPasswordController),
            SizedBox(height: 20),
            _buildPasswordInput('Confirm New Password', _confirmPasswordController),
            SizedBox(height: 30),
            Center(
              child: _buildActionButton('Update Password', _updatePassword),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build email input field
  Widget _buildEmailInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Helper to build password input fields
  Widget _buildPasswordInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  // Helper to build action button
  Widget _buildActionButton(String text, Function onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          backgroundColor: Colors.black, // Use a consistent button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
