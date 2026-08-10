import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class CategoriasChart extends StatelessWidget {
  const CategoriasChart({super.key, required this.categories});

  final List<CategoryDemandIndicator> categories;

  @override
  Widget build(BuildContext context) {
    final maxUnits = categories.fold<int>(
      0,
      (current, item) => item.units > current ? item.units : current,
    );
    return _DashboardCard(
      title: 'Categorías más demandadas',
      child: categories.isEmpty
          ? const Text('No hay información disponible')
          : Column(
              children: categories
                  .map((category) {
                    final progress = maxUnits == 0
                        ? 0.0
                        : category.units / maxUnits;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(category.categoryName)),
                              Text('${category.units} u.'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );
}
