import 'package:flutter/material.dart';

class TopProductosChart extends StatefulWidget {
  const TopProductosChart({super.key});
  @override
  State<TopProductosChart> createState() => _TopProductosChartState();
}

class _TopProductosChartState extends State<TopProductosChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  static const _productos = [
    _Producto('Cuadernos Oxford A4',           1240, Color(0xFF43A047)),
    _Producto('Bolígrafo Pilot G2 Black',       980, Color(0xFF0D4F6C)),
    _Producto('Marcadores Stabilo Boss (Set 6)', 850, Color(0xFFE65100)),
    _Producto('Lápices Faber-Castell 12ud',     720, Color(0xFF90A4AE)),
    _Producto('Papel Fotocopia A4 Multi',        610, Color(0xFFB0BEC5)),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    // Stagger: start slightly delayed so it follows after ventas/categorias
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const maxVal = 1240.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top 5 productos más vendidos',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 18),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Column(
              children: List.generate(_productos.length, (i) {
                final p = _productos[i];
                // Stagger each bar slightly
                final delay = i * 0.12;
                final barProgress = ((_anim.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);

                return Padding(
                  padding: EdgeInsets.only(bottom: i < _productos.length - 1 ? 16 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(p.name,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E))),
                        ),
                        Text('${p.units} u.',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                      ]),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (p.units / maxVal) * barProgress,
                          backgroundColor: const Color(0xFFECEFF1),
                          valueColor: AlwaysStoppedAnimation<Color>(p.color),
                          minHeight: 6,
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

class _Producto {
  final String name;
  final int units;
  final Color color;
  const _Producto(this.name, this.units, this.color);
}