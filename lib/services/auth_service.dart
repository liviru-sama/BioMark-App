// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login method
  Future<bool> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  // Register method
  Future<User?> register({required String email, required String password}) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Password reset
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
