class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.imageUrl = 'https://picsum.photos/200',
  });
}
