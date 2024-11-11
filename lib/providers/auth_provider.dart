import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../utils/encryption_helper.dart'; // Import encryption helper
import 'package:encrypt/encrypt.dart' as encrypt; // Alias the encrypt package

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  UserModel? _userModel;

  UserModel? get user => _userModel;

  // Initialize EncryptionHelper with key and IV
  late final EncryptionHelper encryptionHelper;
  late final FirestoreService _firestoreService;

  AuthProvider() {
    final key = encrypt.Key.fromUtf8('32_characters_long_key_here!'); // Set your actual encryption key
    final iv = encrypt.IV.fromLength(16);
    encryptionHelper = EncryptionHelper(key, iv); // Initialize encryptionHelper
    _firestoreService = FirestoreService(encryptionHelper); // Initialize FirestoreService

    _auth.authStateChanges().listen(_onAuthStateChanged);
    _initializeUser(); // Check for already logged-in user
  }

  Future<void> _initializeUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _onAuthStateChanged(currentUser);
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      try {
        // Fetch user data from Firestore
        _userModel = await _firestoreService.getUser(firebaseUser.uid);
      } catch (e) {
        print('Failed to fetch user data: $e');
      }
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
      await _firestoreService.updateUserField(_userModel!.uid, 'subscriptionStatus', status);
      _userModel = _userModel!.copyWith(subscriptionStatus: status);
      notifyListeners();
    } catch (e) {
      print("Failed to update subscription status: $e");
    }
  }
}
