import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/models/user.dart';
import 'package:template_app/repositories/auth_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required authRepository})
      : _authRepository = authRepository,
        super(const DashboardState()) {
    _products = _authRepository.getProducts();
    _products.snapshots().listen((event) {
      print('CAMBIO desde cubit');
      if (event.metadata.hasPendingWrites) {
        print('CAMBIOS PENDIENTES desde cubit');
      }
      getProducts();
    });
  }
  final AuthenticationRepository _authRepository;
  late CollectionReference _products;

  Future<void> logout() async {
    await _authRepository.signOut();
  }

  Future<void> getProducts() async {
    //final products = await _authRepository.getUserCollection();
    final productsDoc = (await _products.get() as QuerySnapshot<Product>).docs;
    final products = productsDoc.map((e) => e.data()).toList();

    emit(state.copyWith(products: products));
  }

  Future<void> addProduct(String name, int length) async {
    _products.add(
      Product(
        name: name,
        length: length,
      ),
    );
  }
}
