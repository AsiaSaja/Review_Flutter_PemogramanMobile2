import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts() {
    return remoteDataSource.getProducts();
  }

  @override
  Future<Product?> getProductById(String id) {
    return remoteDataSource.getProductById(id);
  }

  @override
  Future<void> addProduct(Product product) {
    final model = ProductModel.fromEntity(product);

    return remoteDataSource.addProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) {
    final model = ProductModel.fromEntity(product);

    return remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) {
    return remoteDataSource.deleteProduct(id);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await remoteDataSource.getProducts();
    final keyword = query.toLowerCase().trim();

    if (keyword.isEmpty) {
      return products;
    }

    return products
        .where((product) {
          return product.name.toLowerCase().contains(keyword) ||
              product.category.toLowerCase().contains(keyword);
        })
        .map<Product>((product) => product)
        .toList();
  }
}
