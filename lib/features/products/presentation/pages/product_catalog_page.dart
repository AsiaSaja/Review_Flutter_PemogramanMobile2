import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:review_flutter_widget/core/widgets/app_state_view.dart';

import '../state/product_notifier.dart';
import '../state/product_state.dart';
import '../widgets/product_card.dart';

import 'product_form_page.dart';
import 'product_detail_page.dart';

class ProductCatalogPage extends ConsumerStatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  ConsumerState<ProductCatalogPage> createState() {
    return _ProductCatalogPageState();
  }
}

class _ProductCatalogPageState extends ConsumerState<ProductCatalogPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hoshika Official Store')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ProductState state) {
    switch (state.status) {
      case ProductStatus.initial:
        return const AppStateView(
          icon: Icons.storefront_outlined,
          title: 'Hoshika Official Store',
          message: 'Memuat catalog product...',
        );

      case ProductStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ProductStatus.success:
        return _buildProductGrid(state);

      case ProductStatus.empty:
        return _buildEmptyState(state);

      case ProductStatus.error:
        return AppStateView(
          icon: Icons.error_outline,
          title: 'Terjadi Kesalahan',
          message: state.message,
          actionLabel: 'Coba Lagi',
          onAction: () {
            ref.read(productNotifierProvider.notifier).loadProducts();
          },
        );
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        onChanged: (value) {
          ref.read(productNotifierProvider.notifier).search(value);
        },
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];

        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(productId: product.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ProductState state) {
    if (state.searchQuery.isNotEmpty) {
      return AppStateView(
        icon: Icons.search_off,
        title: 'Produk Tidak Ditemukan',
        message: 'Tidak ada produk yang cocok dengan "${state.searchQuery}".',
      );
    }

    return const AppStateView(
      icon: Icons.inventory_2_outlined,
      title: 'Belum ada Produk',
      message: 'Tambahkan produk pertama ke katalog',
    );
  }
}
