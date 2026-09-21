import 'package:dio/dio.dart';

import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('/items/products');
    final data = _readDataList(response.data);

    return data.map(ProductModel.fromMap).toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await dio.get('/items/products/$id');
      return ProductModel.fromMap(_readDataMap(response.data));
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await dio.post('/items/products', data: product.toApiMap(includeId: false));
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await dio.patch(
      '/items/products/${product.id}',
      data: product.toApiMap(includeId: false),
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await dio.delete('/items/products/$id');
  }

  List<Map<String, dynamic>> _readDataList(dynamic body) {
    final data = (body as Map<String, dynamic>)['data'];

    if (data is! List) {
      throw const FormatException('Format data produk tidak valid.');
    }

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Map<String, dynamic> _readDataMap(dynamic body) {
    final data = (body as Map<String, dynamic>)['data'];

    if (data is! Map) {
      throw const FormatException('Format detail produk tidak valid.');
    }

    return Map<String, dynamic>.from(data);
  }
}
