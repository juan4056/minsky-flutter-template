import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/models/product.dart';
import 'package:template_app/repositories/data_repository.dart';

part 'form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({required dataRepository})
      : _dataRepository = dataRepository,
        super(const ProductFormState());
  final DataRepository _dataRepository;

  void nameChanged(String? name) {
    emit(state.copyWith(name: name));
  }

  void priceChanged(int? price) {
    emit(state.copyWith(price: price));
  }

  void purchaseDateChanged(DateTime? purchaseDate) {
    emit(state.copyWith(purchaseDate: purchaseDate));
  }

  void marketChanged(String? market) {
    emit(state.copyWith(market: market));
  }

  void quantityChanged(int? quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void observationsChanged(List<String>? observations) {
    emit(state.copyWith(observations: observations));
  }

  void addProduct() {
    _dataRepository.addProduct(Product(
      name: state.name,
      price: state.price,
      purchaseDate: (state.purchaseDate != null)
          ? Timestamp.fromDate(state.purchaseDate!)
          : null,
      market: state.market,
      quantity: state.quantity,
      observations: state.observations,
    ));
  }
}
