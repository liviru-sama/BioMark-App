// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String dateOfBirth;
  final String timeOfBirth;
  final String locationOfBirth;
  final String bloodGroup;
  final String sex;
  final String height;
  final String ethnicity;
  final String eyeColour;
  // Add other fields as necessary

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.locationOfBirth,
    required this.bloodGroup,
    required this.sex,
    required this.height,
    required this.ethnicity,
    required this.eyeColour,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      timeOfBirth: data['timeOfBirth'] ?? '',
      locationOfBirth: data['locationOfBirth'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      sex: data['sex'] ?? '',
      height: data['height'] ?? '',
      ethnicity: data['ethnicity'] ?? '',
      eyeColour: data['eyeColour'] ?? '',
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'timeOfBirth': timeOfBirth,
      'locationOfBirth': locationOfBirth,
      'bloodGroup': bloodGroup,
      'sex': sex,
      'height': height,
      'ethnicity': ethnicity,
      'eyeColour': eyeColour,
      // Add other fields as necessary
    };
  }
}
