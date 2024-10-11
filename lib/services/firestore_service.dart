import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid); // Pass uid here
    }
    return null;
  }
}
