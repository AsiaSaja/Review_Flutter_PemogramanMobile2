// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:review_flutter_widget/main.dart';
import 'package:review_flutter_widget/core/di/injection.dart';
import 'package:review_flutter_widget/features/products/domain/entities/product.dart';
import 'package:review_flutter_widget/features/products/domain/repositories/product_repository.dart';

class _FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => [];

  @override
  Future<Product?> getProductById(String id) async => null;

  @override
  Future<void> addProduct(Product product) async {}

  @override
  Future<void> updateProduct(Product product) async {}

  @override
  Future<void> deleteProduct(String id) async {}

  @override
  Future<List<Product>> searchProducts(String query) async => [];
}

void main() {
  testWidgets('product catalog app renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Hoshika Official Store'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
