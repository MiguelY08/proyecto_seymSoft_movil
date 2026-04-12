import 'package:flutter/material.dart';
import 'dart:math';

class VentasChart extends StatefulWidget {
  const VentasChart({super.key});
  @override
  State<VentasChart> createState() => _VentasChartState();
}

class _VentasChartState extends State<VentasChart>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  static const _ventas       = [20.0, 35.0, 50.0, 45.0, 60.0, 55.0, 70.0, 65.0, 110.0, 90.0, 75.0, 95.0];
  static const _devoluciones = [10.0, 15.0, 20.0, 25.0, 18.0, 22.0, 30.0, 28.0,  35.0, 40.0, 45.0, 38.0];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ventas & Devoluciones',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => SizedBox(
              height: 140,
              child: _LineChartWidget(
                ventas: _ventas,
                devoluciones: _devoluciones,
                progress: _anim.value,
                selectedIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = _selectedIndex == i ? null : i),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Ene', 'Mar', 'May', 'Jul', 'Sep', 'Nov']
                .map((l) => Text(l, style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E))))
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Dot(color: const Color(0xFF0D4F6C), label: 'Ventas'),
              const SizedBox(width: 16),
              _Dot(color: const Color(0xFFB0BEC5), label: 'Devoluciones'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color; final String label;
  const _Dot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF757575))),
  ]);
}

// ── Widget wrapper with gesture ────────────────────────────────────────────
class _LineChartWidget extends StatelessWidget {
  final List<double> ventas, devoluciones;
  final double progress;
  final int? selectedIndex;
  final ValueChanged<int> onTap;

  const _LineChartWidget({
    required this.ventas, required this.devoluciones,
    required this.progress, required this.selectedIndex, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (d) {
        final box = context.findRenderObject() as RenderBox;
        final step = box.size.width / (ventas.length - 1);
        final idx = (d.localPosition.dx / step).round().clamp(0, ventas.length - 1);
        onTap(idx);
      },
      child: CustomPaint(
        painter: _ChartPainter(ventas: ventas, devoluciones: devoluciones, progress: progress, selectedIndex: selectedIndex),
        size: Size.infinite,
      ),
    );
  }
}

// ── Painter ────────────────────────────────────────────────────────────────
class _ChartPainter extends CustomPainter {
  final List<double> ventas, devoluciones;
  final double progress;
  final int? selectedIndex;

  _ChartPainter({required this.ventas, required this.devoluciones, required this.progress, this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final all = [...ventas, ...devoluciones];
    final maxV = all.reduce(max) * 1.1;
    final minV = all.reduce(min) * 0.9;
    final range = maxV - minV;

    double xOf(int i) => i * size.width / (ventas.length - 1);
    double yOf(double v) => size.height - ((v - minV) / range) * size.height;

    // Grid
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 3), Offset(size.width, size.height * i / 3),
        Paint()..color = const Color(0xFFF0F0F0)..strokeWidth = 1,
      );
    }

    // Clip to animated progress
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height + 4));

    // Devoluciones dashed
    _dashed(canvas, devoluciones, xOf, yOf, const Color(0xFFB0BEC5));

    // Ventas gradient fill
    final fill = Path()
      ..moveTo(xOf(0), size.height)
      ..lineTo(xOf(0), yOf(ventas[0]));
    for (int i = 1; i < ventas.length; i++) fill.lineTo(xOf(i), yOf(ventas[i]));
    fill..lineTo(xOf(ventas.length - 1), size.height)..close();
    canvas.drawPath(fill, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [const Color(0xFF0D4F6C).withOpacity(0.14), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill);

    // Ventas line (sharp/pointy)
    final line = Path()..moveTo(xOf(0), yOf(ventas[0]));
    for (int i = 1; i < ventas.length; i++) line.lineTo(xOf(i), yOf(ventas[i]));
    canvas.drawPath(line, Paint()
      ..color = const Color(0xFF0D4F6C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    canvas.restore();

    // Dots on even + last
    for (int i = 0; i < ventas.length; i++) {
      if (i % 2 == 0 || i == ventas.length - 1) {
        canvas.drawCircle(Offset(xOf(i), yOf(ventas[i])), 4, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(xOf(i), yOf(ventas[i])), 3, Paint()..color = const Color(0xFF0D4F6C));
      }
    }

    // Tap tooltip
    if (selectedIndex != null) {
      final si = selectedIndex!;
      final cx = xOf(si); final cy = yOf(ventas[si]);
      canvas.drawLine(Offset(cx, 0), Offset(cx, size.height),
          Paint()..color = const Color(0xFF0D4F6C).withOpacity(0.15)..strokeWidth = 1);
      canvas.drawCircle(Offset(cx, cy), 7, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = const Color(0xFF0D4F6C));

      final tp = TextPainter(
        text: TextSpan(text: '${ventas[si].toInt()}',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr,
      )..layout();
      final ttW = tp.width + 14; const ttH = 24.0;
      final ttX = (cx - ttW / 2).clamp(0.0, size.width - ttW);
      final ttY = (cy - ttH - 12).clamp(0.0, size.height - ttH);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(ttX, ttY, ttW, ttH), const Radius.circular(6)),
          Paint()..color = const Color(0xFF0D4F6C));
      tp.paint(canvas, Offset(ttX + 7, ttY + 5));
    }
  }

  void _dashed(Canvas canvas, List<double> data, double Function(int) xOf, double Function(double) yOf, Color color) {
    final p = Paint()..color = color..strokeWidth = 1.8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    for (int i = 0; i < data.length - 1; i++) {
      final x1 = xOf(i); final y1 = yOf(data[i]);
      final x2 = xOf(i + 1); final y2 = yOf(data[i + 1]);
      final dx = x2 - x1; final dy = y2 - y1;
      final len = sqrt(dx * dx + dy * dy);
      double d = 0; bool on = true;
      while (d < len) {
        final seg = on ? 5.0 : 4.0;
        final t1 = d / len; final t2 = min((d + seg) / len, 1.0);
        if (on) canvas.drawLine(Offset(x1 + dx * t1, y1 + dy * t1), Offset(x1 + dx * t2, y1 + dy * t2), p);
        d += seg; on = !on;
      }
    }
  }

  @override
  bool shouldRepaint(_ChartPainter o) => o.progress != progress || o.selectedIndex != selectedIndex;
}