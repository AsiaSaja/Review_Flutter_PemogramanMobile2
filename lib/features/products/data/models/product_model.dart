import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.quantity,
    required super.description,
    required super.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category']?.toString() ?? 'Tanpa kategori',
      price: double.parse(map['price'].toString()),
      quantity: int.parse(map['quantity'].toString()),
      description: map['description']?.toString() ?? '',
      imageUrl: _assetUrl(
        map['image_url']?.toString() ?? map['imageUrl']?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'quantity': quantity,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toApiMap({bool includeId = true}) {
    return {
      if (includeId) 'id': id,
      'name': name,
      'category': category,
      'price': price,
      'quantity': quantity,
      'description': description,
      'image_url': _assetId(imageUrl),
    };
  }

  static String _assetUrl(String value) {
    if (value.isEmpty || value.startsWith('http')) {
      return value;
    }

    return 'https://pos.cicd.web.id/assets/$value';
  }

  static String _assetId(String value) {
    final uri = Uri.tryParse(value);

    if (uri != null && uri.pathSegments.length >= 2) {
      final assetsIndex = uri.pathSegments.indexOf('assets');

      if (assetsIndex >= 0 && assetsIndex + 1 < uri.pathSegments.length) {
        return uri.pathSegments[assetsIndex + 1];
      }
    }

    return value;
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      quantity: product.quantity,
      description: product.description,
      imageUrl: product.imageUrl,
    );
  }
}
