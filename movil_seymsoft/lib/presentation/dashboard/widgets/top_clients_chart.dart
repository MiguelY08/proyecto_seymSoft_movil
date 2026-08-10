import 'package:flutter/material.dart';

import '../../../data/models/dashboard_models.dart';

class TopClientsChart extends StatelessWidget {
  const TopClientsChart({super.key, required this.clients});
  final List<TopClientIndicator> clients;

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
        const Text(
          'Top 5 clientes del mes',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (clients.isEmpty)
          const Text('No hay información disponible')
        else
          ...clients.indexed.map(
            (entry) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${entry.$1 + 1}')),
              title: Text(entry.$2.clientName),
              trailing: Text('\$${entry.$2.value.toStringAsFixed(0)}'),
            ),
          ),
      ],
    ),
  );
}
