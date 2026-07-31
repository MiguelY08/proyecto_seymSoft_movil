import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class TopProductosChart extends StatelessWidget {
  const TopProductosChart({super.key, required this.products});

  final List<TopProductIndicator> products;

  @override
  Widget build(BuildContext context) {
    final maxValue = products.fold<double>(0, (max, item) => item.value > max ? item.value : max);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Top 5 productos más vendidos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
        if (products.isEmpty)
          const Text('No hay ventas para mostrar')
        else
          ...products.map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(product.productName, overflow: TextOverflow.ellipsis)),
                    Text('${product.value.toStringAsFixed(0)} u.', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: maxValue == 0 ? 0 : product.value / maxValue, minHeight: 6),
                ]),
              )),
      ]),
    );
  }
}
