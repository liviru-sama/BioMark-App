import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _timeOfBirth = TextEditingController();
  final TextEditingController _locationOfBirth = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _ethnicity = TextEditingController();
  final TextEditingController _eyeColor = TextEditingController();
  String _bloodGroup = 'A+'; // Default value for blood group
  String _sex = 'Male'; // Default value for sex
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );

        // Encrypt sensitive data before saving
        final encryptedFullName = encryptData(_fullName.text.trim());

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'fullName': encryptedFullName,
          'email': _email.text.trim(),
          'dateOfBirth': _dateOfBirth.text.trim(),
          'timeOfBirth': _timeOfBirth.text.trim(),
          'locationOfBirth': _locationOfBirth.text.trim(),
          'bloodGroup': _bloodGroup,
          'sex': _sex,
          'height': _height.text.trim(),
          'ethnicity': _ethnicity.text.trim(),
          'eyeColor': _eyeColor.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacementNamed(context, '/profile');
      } on firebase_auth.FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'email-already-in-use') {
          message = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _dateOfBirth.dispose();
    _timeOfBirth.dispose();
    _locationOfBirth.dispose();
    _height.dispose();
    _ethnicity.dispose();
    _eyeColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F5FB), // Light background consistent with login screen
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blue, // Blue text color for consistency
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Text
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Fill in your details to create a new account.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Full Name Field
              _buildTextField(
                controller: _fullName,
                labelText: 'Full Name',
                icon: Icons.person,
              ),
              SizedBox(height: 16.0),

              // Email Field
              _buildTextField(
                controller: _email,
                labelText: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),

              // Password Field
              _buildTextField(
                controller: _password,
                labelText: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 16.0),

              // Date of Birth Field
              _buildTextField(
                controller: _dateOfBirth,
                labelText: 'Date of Birth (YYYY-MM-DD)',
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 16.0),

              // Time of Birth Field
              _buildTextField(
                controller: _timeOfBirth,
                labelText: 'Time of Birth (HH:MM)',
                icon: Icons.access_time,
              ),
              SizedBox(height: 16.0),

              // Location of Birth Field
              _buildTextField(
                controller: _locationOfBirth,
                labelText: 'Location of Birth',
                icon: Icons.location_on,
              ),
              SizedBox(height: 16.0),

              // Blood Group Dropdown
              _buildDropdownField(
                value: _bloodGroup,
                labelText: 'Blood Group',
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                onChanged: (String? newValue) {
                  setState(() {
                    _bloodGroup = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Sex Dropdown
              _buildDropdownField(
                value: _sex,
                labelText: 'Sex',
                items: ['Male', 'Female', 'Other'],
                onChanged: (String? newValue) {
                  setState(() {
                    _sex = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Height Field
              _buildTextField(
                controller: _height,
                labelText: 'Height (cm)',
                icon: Icons.height,
              ),
              SizedBox(height: 16.0),

              // Ethnicity Field
              _buildTextField(
                controller: _ethnicity,
                labelText: 'Ethnicity',
                icon: Icons.people,
              ),
              SizedBox(height: 16.0),

              // Eye Color Field
              _buildTextField(
                controller: _eyeColor,
                labelText: 'Eye Color',
                icon: Icons.remove_red_eye,
              ),
              SizedBox(height: 30),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String labelText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(color: Colors.black87),
    );
  }
}

// Encryption function for security
String encryptData(String plainText) {
  final key = encrypt.Key.fromLength(32); // Store securely
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}
