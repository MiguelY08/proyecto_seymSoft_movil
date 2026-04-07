import 'package:flutter/material.dart';

class KpiCards extends StatefulWidget {
  const KpiCards({super.key});
  @override
  State<KpiCards> createState() => _KpiCardsState();
}

class _KpiCardsState extends State<KpiCards> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.point_of_sale_rounded,
                    iconBg: const Color(0xFFE3F2FD),
                    iconColor: const Color(0xFF1565C0),
                    title: 'Total Ventas',
                    value: '\$45.2M',
                    subtitle: '+12.5% vs el mes pasado',
                    subtitleColor: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.group_rounded,
                    iconBg: const Color(0xFFE0F2F1),
                    iconColor: const Color(0xFF00695C),
                    title: 'Clientes Activos',
                    value: '324',
                    subtitle: 'Activos este mes',
                    subtitleColor: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StockCard(),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, value, subtitle;
  final Color subtitleColor;

  const _StatCard({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.value,
    required this.subtitle, required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF757575))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E), height: 1.1)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: subtitleColor)),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: const Color(0xFFECEFF1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF455A64), size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Productos en stock', style: TextStyle(fontSize: 13, color: Color(0xFF757575))),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                child: const Text('12 bajo stock',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFE65100))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('1,847',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E), height: 1.0)),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Text('Total artículos', style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}