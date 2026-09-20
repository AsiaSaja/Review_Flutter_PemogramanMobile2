import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/product_local_datasource_impl.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';

import '../../features/products/domain/usecases/add_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/get_product_by_id.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/domain/usecases/update_product.dart';

final productBoxProvider = Provider<Box>((ref) {
  return Hive.box('products');
});

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  final box = ref.watch(productBoxProvider);

  return ProductLocalDataSourceImpl(box);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final localDataSource = ref.watch(productLocalDataSourceProvider);

  return ProductRepositoryImpl(localDataSource);
});

final getProductsProvider = Provider<GetProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return GetProducts(repository);
});

final getProductByIdProvider = Provider<GetProductById>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return GetProductById(repository);
});

final addProductProvider = Provider<AddProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return AddProduct(repository);
});

final updateProductProvider = Provider<UpdateProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return UpdateProduct(repository);
});

final deleteProductProvider = Provider<DeleteProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return DeleteProduct(repository);
});

final searchProductsProvider = Provider<SearchProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return SearchProducts(repository);
});
