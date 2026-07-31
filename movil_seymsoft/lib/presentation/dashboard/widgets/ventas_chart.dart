import 'package:flutter/material.dart';
import '../../../data/models/dashboard_models.dart';

class VentasChart extends StatelessWidget {
  const VentasChart({super.key, required this.trends});
  final List<CommercialTrendIndicator> trends;

  @override
  Widget build(BuildContext context) {
    final maxSales = trends.fold<double>(0, (max, item) => item.sales > max ? item.sales : max);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Tendencia comercial', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        if (trends.isEmpty) const Text('Sin ventas registradas'),
        ...trends.map((trend) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                SizedBox(width: 72, child: Text(trend.month, overflow: TextOverflow.ellipsis)),
                Expanded(child: LinearProgressIndicator(value: maxSales == 0 ? 0 : trend.sales / maxSales)),
                const SizedBox(width: 8),
                Text('\$${trend.sales.toStringAsFixed(0)}'),
              ]),
            )),
      ]),
    );
  }
}
