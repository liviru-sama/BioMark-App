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
  final TextEditingController _mothersMaidenName = TextEditingController();
  final TextEditingController _bestFriendName = TextEditingController();
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _customQuestion = TextEditingController();

  String _bloodGroup = 'A+';
  String _sex = 'Male';
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        firebase_auth.UserCredential userCredential =
        await firebase_auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );

        // Encrypt sensitive data before saving
        final encryptedFullName = encryptData(_fullName.text.trim());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': _fullName.text.trim(),
          'email': _email.text.trim(),
          'dateOfBirth': _dateOfBirth.text.trim(),
          'timeOfBirth': _timeOfBirth.text.trim(),
          'locationOfBirth': _locationOfBirth.text.trim(),
          'bloodGroup': _bloodGroup,
          'sex': _sex,
          'height': _height.text.trim(),
          'ethnicity': _ethnicity.text.trim(),
          'eyeColor': _eyeColor.text.trim(),
          'mothersMaidenName': _mothersMaidenName.text.trim(),
          'bestFriendName': _bestFriendName.text.trim(),
          'petName': _petName.text.trim(),
          'customQuestion': _customQuestion.text.trim(),
          'subscriptionStatus': 'on',
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
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
    _mothersMaidenName.dispose();
    _bestFriendName.dispose();
    _petName.dispose();
    _customQuestion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Fill in your details to create a new account.',
                style: TextStyle(
                    fontSize: 16.0, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: _fullName,
                labelText: 'Full Name',
                icon: Icons.person,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _email,
                labelText: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _password,
                labelText: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _dateOfBirth,
                labelText: 'Date of Birth (YYYY-MM-DD)',
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _timeOfBirth,
                labelText: 'Time of Birth (HH:MM)',
                icon: Icons.access_time,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _locationOfBirth,
                labelText: 'Location of Birth',
                icon: Icons.location_on,
              ),
              SizedBox(height: 16.0),
              _buildDropdownField(
                value: _bloodGroup,
                labelText: 'Blood Group',
                items: [
                  'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _bloodGroup = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
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
              _buildTextField(
                controller: _height,
                labelText: 'Height (cm)',
                icon: Icons.height,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _ethnicity,
                labelText: 'Ethnicity',
                icon: Icons.people,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _eyeColor,
                labelText: 'Eye Color',
                icon: Icons.remove_red_eye,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _mothersMaidenName,
                labelText: 'Mother\'s Maiden Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _bestFriendName,
                labelText: 'Childhood Best Friend\'s Name',
                icon: Icons.person_pin,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _petName,
                labelText: 'Childhood Pet\'s Name',
                icon: Icons.pets,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _customQuestion,
                labelText: 'Your Own Question',
                icon: Icons.question_answer,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
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
                      color: Colors.white,
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
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Standardizing padding
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Standardizing padding
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  String encryptData(String data) {
    // Example encryption logic (you would replace this with your actual encryption method)
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }
}
