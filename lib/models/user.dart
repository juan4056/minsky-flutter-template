import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  const MyUser({required this.products});

  factory MyUser.fromJson(String str) =>
      MyUser.fromMap(json.decode(str) as Map<String, dynamic>);

  factory MyUser.fromMap(Map<String, dynamic> json) => MyUser(
      products: (json['Products'] as Map<String, dynamic>)
          .map<String, int>((key, value) => MapEntry(key, value as int)));

  final Map<String, int>? products;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        'Products': products,
      };

  @override
  List<Object?> get props => [products];
}

class Product {
  Product({required this.name, required this.length});

  factory Product.fromMap(Map<String, Object?> json) => Product(
        name: json['name'] as String,
        length: json['length'] as int,
      );

  final String name;
  final int length;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'length': length,
    };
  }
}
