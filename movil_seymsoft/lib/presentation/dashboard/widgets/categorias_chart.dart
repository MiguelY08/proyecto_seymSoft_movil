import 'package:flutter/material.dart';
import '../../../data/models/dashboard_models.dart';

class CategoriasChart extends StatelessWidget {
  const CategoriasChart({super.key, required this.categories});
  final List<CategoryDemandIndicator> categories;

  @override
  Widget build(BuildContext context) {
    final maxUnits = categories.fold<int>(0, (max, item) => item.units > max ? item.units : max);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Categorías más demandadas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        if (categories.isEmpty) const Text('Sin información disponible'),
        ...categories.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${category.categoryName} (${category.units})'),
                LinearProgressIndicator(value: maxUnits == 0 ? 0 : category.units / maxUnits),
              ]),
            )),
      ]),
    );
  }
}
