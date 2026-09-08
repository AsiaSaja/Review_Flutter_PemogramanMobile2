import 'dart:math';
import '../models/product.dart';

class ProductRepository {
  static final List<Product> _products = [
    Product(
      id: '1',
      name: 'Plushie Kaela Kovalskia Hololive',
      price: 750000,
      description: 'Merchandise Official dari Vtuber Indonesia Kaela Kovalskia',
      category: 'Merchandise',
      imageUrl:
          'https://i.pinimg.com/1200x/d2/1b/e3/d21be35210e0491c09afd7607b482e13.jpg',
    ),
    Product(
      id: '2',
      name: 'T-Shirt Anime Bocchi The Rock',
      price: 150000,
      description: 'T-Shirt Fanmade untuk kamu yang menyukai Bocchi The Rock',
      category: 'Fashion',
      imageUrl:
          'https://i.pinimg.com/1200x/b5/4d/0e/b54d0ed1ab585bb57f38e01b70f47387.jpg',
    ),
    Product(
      id: '3',
      name: 'Keychain Blue Archive',
      price: 25000,
      description: 'Gantungan kunci dari game gacha populer Blue Archive',
      category: 'Merchandise',
      imageUrl:
          'https://i.pinimg.com/1200x/39/27/a6/3927a6d46395838209b9beed86e7c871.jpg',
    ),
  ];

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    if (Random().nextInt(100) < 20) {
      throw Exception('Gagal memuat data. Periksa Koneksi anda');
    }
    return List.unmodifiable(_products);
  }

  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    if (product.name.isEmpty || product.price <= 0) {
      throw Exception('Data produk tidak valid.');
    }
    _products.add(product);
  }
}
