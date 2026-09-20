import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getProducts() {
    return localDataSource.getProducts();
  }

  @override
  Future<Product?> getProductById(String id) {
    return localDataSource.getProductById(id);
  }

  @override
  Future<void> addProduct(Product product) {
    final model = ProductModel.fromEntity(product);

    return localDataSource.addProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) {
    final model = ProductModel.fromEntity(product);

    return localDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) {
    return localDataSource.deleteProduct(id);
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return localDataSource.searchProducts(query);
  }
}
