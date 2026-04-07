import 'package:flutter/material.dart';

class TopClientsChart extends StatefulWidget {
  const TopClientsChart({super.key});
  @override
  State<TopClientsChart> createState() => _TopClientsChartState();
}

class _TopClientsChartState extends State<TopClientsChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  static const _clients = [
    ('Comercial Express S.A.', '\$2.5M', 1.00, Color(0xFF1976D2)),
    ('Librería El Estudiante',  '\$2.2M', 0.88, Color(0xFF00838F)),
    ('Colegio San Martín',      '\$1.9M', 0.76, Color(0xFFE65100)),
    ('Oficinas Corporativas',   '\$1.6M', 0.64, Color(0xFF455A64)),
    ('Papelería Central',       '\$1.1M', 0.44, Color(0xFF78909C)),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(width: 8),
              Text('Top 5 Clientes del Mes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Column(
              children: List.generate(_clients.length, (i) {
                final (name, amount, progress, color) = _clients[i];
                final delay = i * 0.12;
                final barProgress = ((_anim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);

                return Padding(
                  padding: EdgeInsets.only(bottom: i < _clients.length - 1 ? 16 : 0),
                  child: Column(
                    children: [
                      Row(children: [
                        SizedBox(
                          width: 20,
                          child: Text('${i + 1}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF757575))),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400,
                                color: const Color(0xFF1A1A2E),
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(amount,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                      ]),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress * barProgress,
                            backgroundColor: const Color(0xFFECEFF1),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}