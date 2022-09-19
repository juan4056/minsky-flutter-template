part of 'form_cubit.dart';

class ProductFormState extends Equatable {
  const ProductFormState({
    this.name,
    this.price,
    this.purchaseDate,
    this.market,
    this.quantity,
    this.observations,
  });

  final String? name;
  final int? price;
  final DateTime? purchaseDate;
  final String? market;
  final int? quantity;
  final List<String>? observations;

  @override
  List<Object?> get props => [
        name,
        price,
        purchaseDate,
        market,
        quantity,
        observations,
      ];

  ProductFormState copyWith({
    String? name,
    int? price,
    DateTime? purchaseDate,
    String? market,
    int? quantity,
    List<String>? observations,
  }) {
    return ProductFormState(
      name: name == '' ? null : name ?? this.name,
      price: price == -1 ? null : price ?? this.price,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      market: market == '' ? null : market ?? this.market,
      quantity: quantity == -1 ? null : quantity ?? this.quantity,
      observations: observations ?? this.observations,
    );
  }
}
