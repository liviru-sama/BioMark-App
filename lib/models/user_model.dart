import '../utils/encryption_helper.dart';

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
  final String motherMaidenName;
  final String childhoodBestFriend;
  final String childhoodPetName;
  final String ownQuestion;
  final String ownAnswer;
  final String subscriptionStatus;

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
    this.subscriptionStatus = 'on', // Default subscription status to "on"
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data, String uid, EncryptionHelper encryptionHelper) {
    return UserModel(
      uid: uid,
      fullName: data['fullName'] ?? '', // No decryption for fullName
      email: data['email'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      timeOfBirth: data['timeOfBirth'] ?? '',
      locationOfBirth: data['locationOfBirth'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      sex: data['sex'] ?? '',
      height: data['height'] ?? '',
      ethnicity: data['ethnicity'] ?? '',
      eyeColour: data['eyeColour'] ?? '',
      motherMaidenName: decryptField(data['motherMaidenName'], encryptionHelper),
      childhoodBestFriend: decryptField(data['childhoodBestFriend'], encryptionHelper),
      childhoodPetName: decryptField(data['childhoodPetName'], encryptionHelper),
      ownQuestion: decryptField(data['ownQuestion'], encryptionHelper),
      ownAnswer: decryptField(data['ownAnswer'], encryptionHelper),
      subscriptionStatus: data['subscriptionStatus'] ?? 'on',
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap(EncryptionHelper encryptionHelper) {
    return {
      'fullName': fullName, // No encryption for fullName
      'email': email,
      'dateOfBirth': dateOfBirth,
      'timeOfBirth': timeOfBirth,
      'locationOfBirth': locationOfBirth,
      'bloodGroup': bloodGroup,
      'sex': sex,
      'height': height,
      'eyeColour': eyeColour,
      'motherMaidenName': encryptionHelper.encrypt(motherMaidenName),
      'childhoodBestFriend': encryptionHelper.encrypt(childhoodBestFriend),
      'childhoodPetName': encryptionHelper.encrypt(childhoodPetName),
      'ownQuestion': encryptionHelper.encrypt(ownQuestion),
      'ownAnswer': encryptionHelper.encrypt(ownAnswer),
      'subscriptionStatus': subscriptionStatus,
    };
  }

  // CopyWith method to modify fields without modifying the original object
  UserModel copyWith({
    String? fullName,
    String? email,
    String? subscriptionStatus,
    // Add other fields here as needed
  }) {
    return UserModel(
      uid: this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      dateOfBirth: this.dateOfBirth,
      timeOfBirth: this.timeOfBirth,
      locationOfBirth: this.locationOfBirth,
      bloodGroup: this.bloodGroup,
      sex: this.sex,
      height: this.height,
      ethnicity: this.ethnicity,
      eyeColour: this.eyeColour,
      motherMaidenName: this.motherMaidenName,
      childhoodBestFriend: this.childhoodBestFriend,
      childhoodPetName: this.childhoodPetName,
      ownQuestion: this.ownQuestion,
      ownAnswer: this.ownAnswer,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }

  // Helper function to decrypt fields and ensure non-nullable strings
  static String decryptField(String? value, EncryptionHelper encryptionHelper) {
    if (value == null || value.isEmpty) return '';
    try {
      return encryptionHelper.decrypt(value);
    } catch (e) {
      print("Decryption failed for field: $value. Error: $e");
      return ''; // Return an empty string if decryption fails
    }
  }
}
