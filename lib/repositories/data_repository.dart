import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_app/models/product.dart';

class DataRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  User? _user;

  DataRepository(this._auth, this._firestore) {
    _init();
  }

  CollectionReference getProducts() {
    return _firestore
        .collection('users/${_user!.uid}/products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromMap(snapshot.data()!),
          toFirestore: (product, _) => product.toMap(),
        );
  }

  void addProduct(Product newProduct) {
    final products = getProducts();
    products.add(newProduct);
  }

  void _init() async {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen(
      (User? user) {
        _user = user;
      },
    );
  }
}
