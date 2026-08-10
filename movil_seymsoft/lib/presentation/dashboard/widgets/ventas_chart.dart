import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class VentasChart extends StatelessWidget {
  const VentasChart({super.key, required this.trends});
  final List<CommercialTrendIndicator> trends;

  @override
  Widget build(BuildContext context) {
    final maxSales = trends.fold<double>(
      0,
      (current, item) => item.sales > current ? item.sales : current,
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
            'Tendencia comercial',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (trends.isEmpty)
            const Text('No hay información disponible')
          else
            ...trends.map(
              (trend) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(width: 70, child: Text(trend.month)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: maxSales == 0 ? 0 : trend.sales / maxSales,
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('\$${trend.sales.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
