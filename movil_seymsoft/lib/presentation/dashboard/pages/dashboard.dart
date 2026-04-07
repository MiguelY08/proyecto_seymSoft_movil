// dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/kpi_cards.dart';
import '../widgets/top_clients_chart.dart';
import '../widgets/ventas_chart.dart';
import '../widgets/categorias_chart.dart';
import '../widgets/top_productos_chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // ── KPIs ──────────────────────────────────────────
            Text('GRAFICAS ACTUALES',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0), letterSpacing: 1.3)),
            SizedBox(height: 14),
            KpiCards(),
            SizedBox(height: 12),
            TopClientsChart(),

            SizedBox(height: 24),

            // ── Ventas ────────────────────────────────────────
            Text('ANÁLISIS DE VENTAS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0), letterSpacing: 1.3)),
            SizedBox(height: 14),
            VentasChart(),
            SizedBox(height: 12),
            CategoriasChart(),
            SizedBox(height: 12),
            TopProductosChart(),
          ],
        ),
      ),
    );
  }
}