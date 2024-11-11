import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/encryption_helper.dart';

class FirestoreService {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final EncryptionHelper encryptionHelper;

  FirestoreService(this.encryptionHelper);

  Future<UserModel?> getUser(String uid) async {
    try {
      final userData = await firestoreInstance.collection('users').doc(uid).get();
      if (userData.exists) {
        // Pass userData, uid, and encryptionHelper to fromMap
        return UserModel.fromMap(userData.data()!, uid, encryptionHelper);
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
    return null;
  }

  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await firestoreInstance.collection('users').doc(uid).update({field: value});
    } catch (e) {
      print("Failed to update user field: $e");
    }
  }
}
