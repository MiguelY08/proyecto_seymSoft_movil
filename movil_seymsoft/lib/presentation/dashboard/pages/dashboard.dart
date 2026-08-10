// dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/kpi_cards.dart';
import '../widgets/top_clients_chart.dart';
import '../widgets/ventas_chart.dart';
import '../widgets/categorias_chart.dart';
import '../widgets/top_productos_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        DashboardRepository(ApiClient(TokenStorage())),
      )..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading && state.indicators == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.status == DashboardStatus.failure) {
          return Scaffold(
            body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(state.errorMessage ?? 'No fue posible cargar el dashboard'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<DashboardCubit>().loadDashboard(refresh: true),
                  child: const Text('Reintentar'),
                ),
              ]),
            ),
          );
        }
        final indicators = state.indicators;
        if (indicators == null) return const SizedBox.shrink();
        return _DashboardContent(indicators: indicators);
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.indicators});

  final DashboardIndicators indicators;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().loadDashboard(refresh: true),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── KPIs ──────────────────────────────────────────
              const Text('GRAFICAS ACTUALES',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: Color(0xFF1565C0), letterSpacing: 1.3)),
              const SizedBox(height: 14),
              KpiCards(indicators: indicators),
              const SizedBox(height: 12),
              TopClientsChart(clients: indicators.topClients),

              const SizedBox(height: 24),

              // ── Ventas ────────────────────────────────────────
              const Text('ANÁLISIS DE VENTAS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: Color(0xFF1565C0), letterSpacing: 1.3)),
              const SizedBox(height: 14),
              VentasChart(trends: indicators.commercialTrends),
              const SizedBox(height: 12),
              CategoriasChart(categories: indicators.categoryDemand),
              const SizedBox(height: 12),
              TopProductosChart(products: indicators.topProducts),
            ],
          ),
        ),
      ),
    );
  }
}
