import 'package:flutter/material.dart';
import '../../../data/models/dashboard_models.dart';

class TopClientsChart extends StatelessWidget {
  const TopClientsChart({super.key, required this.clients});
  final List<TopClientIndicator> clients;

  @override
  Widget build(BuildContext context) => _ListCard(
        title: 'Top 5 clientes del mes',
        items: clients.map((client) => '${client.clientName}  ·  \$${client.value.toStringAsFixed(0)}').toList(),
      );
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.title, required this.items});
  final String title;
  final List<String> items;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          if (items.isEmpty) const Text('Sin información disponible'),
          ...items.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${entry.key + 1}. ${entry.value}', overflow: TextOverflow.ellipsis),
              )),
        ]),
      );
}
