import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel?> getProductById(String id);

  Future<void> addProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);

  Future<List<ProductModel>> searchProducts(String query);
}
