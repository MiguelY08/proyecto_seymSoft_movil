import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class KpiCards extends StatelessWidget {
  const KpiCards({super.key, required this.indicators});

  final DashboardIndicators indicators;

  String get _sales => '\$${indicators.monthlySales.currentMonthSales.toStringAsFixed(0)}';
  String get _growth => '${indicators.monthlySales.growthPercentage.toStringAsFixed(1)}% vs el mes pasado';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.point_of_sale_rounded,
                title: 'Ventas del mes',
                value: _sales,
                subtitle: _growth,
                subtitleColor: indicators.monthlySales.growthPercentage >= 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.group_rounded,
                title: 'Clientes activos',
                value: '${indicators.activeClients}',
                subtitle: 'Registrados activos',
                subtitleColor: const Color(0xFF00695C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StockCard(units: indicators.stock.totalUnitsInStock),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.title, required this.value, required this.subtitle, required this.subtitleColor});
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: const Color(0xFF1565C0)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: subtitleColor)),
        ]),
      );
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.units});
  final int units;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          const Icon(Icons.inventory_2_rounded, color: Color(0xFF455A64)),
          const SizedBox(width: 12),
          const Expanded(child: Text('Productos en stock')),
          Text('$units', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
        ]),
      );
}
