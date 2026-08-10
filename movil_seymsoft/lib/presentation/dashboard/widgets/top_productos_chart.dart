import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class TopProductosChart extends StatelessWidget {
  const TopProductosChart({super.key, required this.products});
  final List<TopProductIndicator> products;

  @override
  Widget build(BuildContext context) {
    final maxValue = products.fold<double>(
      0,
      (current, item) => item.value > current ? item.value : current,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 5 productos más vendidos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (products.isEmpty)
            const Text('No hay información disponible')
          else
            ...products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(product.productName)),
                        Text(product.value.toStringAsFixed(0)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: maxValue == 0 ? 0 : product.value / maxValue,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
