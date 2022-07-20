part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.products = const <Product>[],
  });

  final List<Product> products;

  @override
  List<Object> get props => [products];

  DashboardState copyWith({List<Product>? products}) {
    return DashboardState(products: products ?? this.products);
  }
}
