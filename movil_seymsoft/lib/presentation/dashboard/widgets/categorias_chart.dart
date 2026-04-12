import 'package:flutter/material.dart';
import 'dart:math';

class CategoriasChart extends StatefulWidget {
  const CategoriasChart({super.key});
  @override
  State<CategoriasChart> createState() => _CategoriasChartState();
}

class _CategoriasChartState extends State<CategoriasChart>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  static const _data = [
    _Category('Escritura', 0.45, Color(0xFF0D4F6C)),
    _Category('Papelería', 0.30, Color(0xFF5B9DBF)),
    _Category('Arte',      0.15, Color(0xFFB0BEC5)),
    _Category('Otros',     0.10, Color(0xFFDEE3E6)),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _handleTap(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;
    final dist = sqrt(dx * dx + dy * dy);
    final radius = min(size.width, size.height) / 2;
    const strokeW = 22.0;

    // Only register tap within the ring
    if (dist < radius - strokeW || dist > radius) {
      setState(() => _selectedIndex = null);
      return;
    }

    // Compute angle
    double angle = atan2(dy, dx) + pi / 2;
    if (angle < 0) angle += 2 * pi;

    // Find which segment was tapped
    double start = 0;
    for (int i = 0; i < _data.length; i++) {
      final sweep = 2 * pi * _data[i].value;
      if (angle >= start && angle <= start + sweep) {
        setState(() => _selectedIndex = _selectedIndex == i ? null : i);
        return;
      }
      start += sweep;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedIndex != null ? _data[_selectedIndex!] : null;

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
          const Text('Categorías Más Demandadas',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 20),
          Row(
            children: [
              // Donut
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => GestureDetector(
                  onTapUp: (d) {
                    
                    // Find the donut's render box via a key
                    _handleTap(d.localPosition, const Size(130, 130));
                  },
                  child: SizedBox(
                    width: 130, height: 130,
                    child: CustomPaint(
                      painter: _DonutPainter(
                        progress: _anim.value,
                        data: _data,
                        selectedIndex: _selectedIndex,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: selected != null
                              ? Column(
                                  key: ValueKey(selected.name),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${(selected.value * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: selected.color,
                                      ),
                                    ),
                                    Text(
                                      selected.name,
                                      style: const TextStyle(fontSize: 9, color: Color(0xFF9E9E9E), letterSpacing: 0.5),
                                    ),
                                  ],
                                )
                              : const Column(
                                  key: ValueKey('default'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('1.8k',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                                    Text('UNIDADES',
                                        style: TextStyle(fontSize: 8, color: Color(0xFF9E9E9E), letterSpacing: 0.8)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_data.length, (i) {
                    final c = _data[i];
                    final isSelected = _selectedIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = _selectedIndex == i ? null : i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: isSelected ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: isSelected ? c.color.withOpacity(0.08) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: isSelected ? 12 : 10,
                              height: isSelected ? 12 : 10,
                              decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${c.name} (${(c.value * 100).toInt()}%)',
                              style: TextStyle(
                                fontSize: isSelected ? 12.5 : 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? c.color : const Color(0xFF424242),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String name;
  final double value;
  final Color color;
  const _Category(this.name, this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final double progress;
  final List<_Category> data;
  final int? selectedIndex;

  const _DonutPainter({required this.progress, required this.data, this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    const strokeW = 22.0;
    const selectedExtra = 5.0;

    double startAngle = -pi / 2;

    for (int i = 0; i < data.length; i++) {
      final sweep = 2 * pi * data[i].value * progress;
      final isSelected = selectedIndex == i;
      final r = isSelected ? radius - strokeW / 2 + selectedExtra / 2 : radius - strokeW / 2;
      final w = isSelected ? strokeW + selectedExtra : strokeW;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        startAngle,
        sweep - 0.04,
        false,
        Paint()
          ..color = data[i].color
          ..style = PaintingStyle.stroke
          ..strokeWidth = w
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter o) => o.progress != progress || o.selectedIndex != selectedIndex;
}