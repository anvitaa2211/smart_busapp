import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _role;

  User? get user => _user;
  String? get role => _role;

  // ================= SIGNUP =================
  Future<void> signup(String email, String password, String role) async {
    try {
      UserCredential cred =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = cred.user;

      await _firestore.collection('users').doc(_user!.uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _role = role;

      await _subscribeToTopics();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOGIN (FIXED) =================
  Future<void> login(String email, String password) async {
    try {
      UserCredential cred =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = cred.user;

      DocumentSnapshot doc =
      await _firestore.collection('users').doc(_user!.uid).get();

      final data = doc.data() as Map<String, dynamic>?;

      // 🔥 SAFE ROLE FETCH (NO CRASH)
      _role = data?['role'] ?? 'student';

      // 🔁 AUTO-FIX OLD USERS (OPTIONAL BUT SAFE)
      if (data == null || !data.containsKey('role')) {
        await _firestore.collection('users').doc(_user!.uid).update({
          'role': _role,
        });
      }

      await _subscribeToTopics();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _role = null;
    notifyListeners();
  }

  // ================= FCM =================
  Future<void> _subscribeToTopics() async {
    await FirebaseMessaging.instance.subscribeToTopic('holidays');

    String? token = await FirebaseMessaging.instance.getToken();

    if (_user != null) {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({'fcmToken': token});
    }
  }
}