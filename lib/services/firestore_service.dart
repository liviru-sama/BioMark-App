import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Method to create a new user in Firestore
  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  // Method to retrieve user data from Firestore
  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid); // Pass uid here
    }
    return null;
  }

  // Method to update a specific field in the user's document
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await _usersCollection.doc(uid).update({field: value});
    } catch (e) {
      print("Failed to update user field: $e");
    }
  }
}
