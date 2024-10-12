// lib/models/user_model.dart
import 'package:encrypt/encrypt.dart' as encrypt;

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

  // New fields for security questions
  final String motherMaidenName;
  final String childhoodBestFriend;
  final String childhoodPetName;
  final String ownQuestion;
  final String ownAnswer;

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
    required this.motherMaidenName,
    required this.childhoodBestFriend,
    required this.childhoodPetName,
    required this.ownQuestion,
    required this.ownAnswer,
  });

  // Encrypt data function for sensitive fields
  static String encryptData(String plainText) {
    final key = encrypt.Key.fromLength(32); // Store this key securely
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

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
      motherMaidenName: data['motherMaidenName'] ?? '',
      childhoodBestFriend: data['childhoodBestFriend'] ?? '',
      childhoodPetName: data['childhoodPetName'] ?? '',
      ownQuestion: data['ownQuestion'] ?? '',
      ownAnswer: data['ownAnswer'] ?? '',
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
      'motherMaidenName': motherMaidenName,
      'childhoodBestFriend': childhoodBestFriend,
      'childhoodPetName': childhoodPetName,
      'ownQuestion': ownQuestion,
      'ownAnswer': ownAnswer,
    };
  }
}
