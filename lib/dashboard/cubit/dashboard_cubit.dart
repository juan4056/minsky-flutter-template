import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/models/product.dart';
import 'package:template_app/repositories/auth_repository.dart';
import 'package:template_app/repositories/data_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required authRepository, required dataRepository})
      : _authRepository = authRepository,
        _dataRepository = dataRepository,
        super(const DashboardState()) {
    _products = _dataRepository.getProducts();
    _products.snapshots().listen((event) {
      getProducts();
    });
  }
  final AuthenticationRepository _authRepository;
  final DataRepository _dataRepository;
  late CollectionReference _products;

  Future<void> logout() async {
    await _authRepository.signOut();
  }

  Future<void> getProducts() async {
    final productsDoc = (await _products.get() as QuerySnapshot<Product>).docs;
    final products = productsDoc.map((e) => e.data()).toList();

    emit(state.copyWith(products: products));
  }
}
