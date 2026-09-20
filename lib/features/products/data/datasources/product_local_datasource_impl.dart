import 'package:hive/hive.dart';

import '../models/product_model.dart';
import 'product_local_datasource.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl(this.box);

  @override
  Future<List<ProductModel>> getProducts() async {
    final products = box.values.toList();

    return products
        .map((item) => ProductModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final data = box.get(id);

    if (data == null) {
      return null;
    }

    return ProductModel.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await box.put(product.id, product.toMap());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await box.put(product.id, product.toMap());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await getProducts();

    final keyword = query.toLowerCase().trim();

    if (keyword.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword);
    }).toList();
  }
}
