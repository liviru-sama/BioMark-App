// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  UserModel? _userModel;

  UserModel? get user => _userModel;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      _userModel = await FirestoreService().getUser(firebaseUser.uid);
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  // Logout method
  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();
      _userModel = null;
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  // Method to update subscription status
  Future<void> updateSubscriptionStatus(String status) async {
    if (_userModel == null) return;
    try {
      await FirestoreService().updateUserField(_userModel!.uid, 'subscriptionStatus', status);
      _userModel = _userModel!.copyWith(subscriptionStatus: status);
      notifyListeners();
    } catch (e) {
      print("Failed to update subscription status: $e");
    }
  }
}
