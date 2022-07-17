import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth;
  User? _user;

  AuthenticationRepository(this._auth) {
    _init();
  }

  Future<User?> user() async {
    return _user;
  }

  void _init() async {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen(
      (User? user) {
        _user = user;
      },
    );
  }

  Future<void> signInWithCredentials(
      String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
