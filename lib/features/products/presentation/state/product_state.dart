import '../../domain/entities/product.dart';

enum ProductStatus { initial, loading, success, empty, error }

class ProductState {
  final ProductStatus status;
  final List<Product> products;
  final String message;
  final String searchQuery;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.message = '',
    this.searchQuery = '',
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? message,
    String? searchQuery,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
