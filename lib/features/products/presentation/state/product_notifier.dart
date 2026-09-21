import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import 'product_state.dart';

final productNotifierProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<ProductState> {
  late final GetProducts getProducts;
  late final GetProductById getProductById;
  late final AddProduct addProduct;
  late final UpdateProduct updateProduct;
  late final DeleteProduct deleteProduct;
  late final SearchProducts searchProducts;

  @override
  ProductState build() {
    getProducts = ref.watch(getProductsProvider);
    getProductById = ref.watch(getProductByIdProvider);
    addProduct = ref.watch(addProductProvider);
    updateProduct = ref.watch(updateProductProvider);
    deleteProduct = ref.watch(deleteProductProvider);
    searchProducts = ref.watch(searchProductsProvider);

    return const ProductState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(status: ProductStatus.loading, message: '');

    try {
      final products = await getProducts();

      if (products.isEmpty) {
        state = state.copyWith(status: ProductStatus.empty, products: []);

        return;
      }

      state = state.copyWith(status: ProductStatus.success, products: products);
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        message: _errorMessage('Gagal mengambil data produk', e),
      );
    }
  }

  Future<void> add(Product product) async {
    try {
      await addProduct(product);
      await loadProducts();
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        message: _errorMessage('Gagal menambahkan produk', e),
      );
    }
  }

  Future<void> update(Product product) async {
    try {
      await updateProduct(product);
      await loadProducts();
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        message: _errorMessage('Gagal mengubah produk', e),
      );
    }
  }

  Future<bool> delete(String id) async {
    try {
      await deleteProduct(id);
      await loadProducts();

      return true;
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        message: _errorMessage('Gagal menghapus produk', e),
      );

      return false;
    }
  }

  Future<Product?> getById(String id) {
    return getProductById(id);
  }

  Future<void> search(String query) async {
    state = state.copyWith(status: ProductStatus.loading, searchQuery: query);

    try {
      final products = await searchProducts(query);

      if (products.isEmpty) {
        state = state.copyWith(status: ProductStatus.empty, products: []);

        return;
      }

      state = state.copyWith(status: ProductStatus.success, products: products);
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        message: _errorMessage('Gagal mencari produk', e),
      );
    }
  }

  String _errorMessage(String fallback, Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final detail = error.response?.data is Map
          ? (error.response?.data['errors'] ?? error.response?.data['message'])
          : null;

      if (statusCode != null) {
        return '$fallback (HTTP $statusCode)${detail == null ? '' : ': $detail'}';
      }

      return '$fallback: ${error.message ?? error.type.name}';
    }

    return '$fallback: $error';
  }
}
