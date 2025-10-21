import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = const [
      _ProductSummary(id: '1', name: 'Senka Perfect Whip', price: '96.000đ', tags: ['Làm sạch', 'Chiết xuất tơ tằm']),
      _ProductSummary(id: '2', name: 'Paula’s Choice BHA 2%', price: '335.000đ', tags: ['Tẩy tế bào chết', 'Giảm mụn']),
      _ProductSummary(id: '3', name: 'Skin1004 Ampoule', price: '420.000đ', tags: ['Phục hồi', 'Giảm đỏ']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm gợi ý'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.l),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
            child: ListTile(
              title: Text(product.name),
              subtitle: Wrap(
                spacing: AppSpacing.s,
                children: product.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(product.price, style: const TextStyle(fontWeight: FontWeight.w600)),
                  TextButton(onPressed: () => context.push('/products/${product.id}'), child: const Text('Chi tiết')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sản phẩm #$productId')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Senka Perfect Whip', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.s),
              const Text('BeautyStore Official • 96.000đ'),
              const SizedBox(height: AppSpacing.l),
              const Text('Mô tả'),
              const SizedBox(height: AppSpacing.s),
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Sữa rửa mặt tạo bọt mịn, làm sạch sâu nhưng vẫn giữ độ ẩm tự nhiên cho da. Thành phần chiết xuất tơ tằm trắng, hyaluronic acid. '
                    'Phù hợp cho da thường đến da hỗn hợp.',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Thêm vào routine'),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Mua ngay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSummary {
  final String id;
  final String name;
  final String price;
  final List<String> tags;

  const _ProductSummary({required this.id, required this.name, required this.price, required this.tags});
}
