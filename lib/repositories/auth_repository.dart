import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_app/models/user.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  User? _user;

  AuthenticationRepository(this._auth, this._firestore) {
    _init();
  }

  Future<User?> user() async {
    return _user;
  }

  Future<MyUser?> getUserCollection() async {
    if (_user != null) {
      final snapshot = _firestore.doc('users/${_user!.uid}');
      final data = await snapshot.get();
      if (data.exists) {
        return MyUser.fromMap(data.data() ?? <String, dynamic>{});
      }
    }
    return null;
  }

  CollectionReference getProducts() {
    return _firestore
        .collection('users/${_user!.uid}/products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromMap(snapshot.data()!),
          toFirestore: (product, _) => product.toMap(),
        );
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
