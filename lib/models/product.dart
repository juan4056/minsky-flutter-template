import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    this.name,
    this.price,
    this.purchaseDate,
    this.market,
    this.quantity,
    this.observations,
  });

  factory Product.fromMap(Map<String, Object?> json) => Product(
        name: json['name'] as String?,
        price: json['price'] as int?,
        purchaseDate: json['purchase_date'] as Timestamp?,
        market: json['market'] as String?,
        quantity: json['quantity'] as int?,
        observations: List<String>.from(
          (json['observations'] as List<dynamic>?)
                  ?.map<dynamic>((e) => (e as String)) ??
              List.empty(),
        ),
      );

  final String? name;
  final int? price;
  final Timestamp? purchaseDate;
  final String? market;
  final int? quantity;
  final List<String>? observations;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'length': price,
      'purchase_date': purchaseDate,
      'market': market,
      'quantity': quantity,
      'observations': observations,
    };
  }

  @override
  List<Object?> get props => [
        name,
        price,
        purchaseDate,
        market,
        quantity,
        observations,
      ];
}
