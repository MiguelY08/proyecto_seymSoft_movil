import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class KpiCards extends StatelessWidget {
  const KpiCards({super.key, required this.indicators});

  final DashboardIndicators indicators;

  @override
  Widget build(BuildContext context) {
    final growth = indicators.monthlySales.growthPercentage;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.point_of_sale_rounded,
                title: 'Ventas del mes',
                value: _money(indicators.monthlySales.currentMonthSales),
                subtitle:
                    '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                color: growth >= 0
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
                color: const Color(0xFF00695C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          icon: Icons.inventory_2_rounded,
          title: 'Productos en stock',
          value: '${indicators.stock.totalUnitsInStock}',
          subtitle: 'Total de unidades',
          color: const Color(0xFF455A64),
        ),
      ],
    );
  }

  String _money(double value) => '\$${value.toStringAsFixed(0)}';
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
