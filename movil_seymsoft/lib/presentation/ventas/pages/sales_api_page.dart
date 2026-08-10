import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/sale_models.dart';
import '../cubit/sales_cubit.dart';
import '../widgets/venta_card.dart';
import 'ventas_page.dart';

class SalesApiPage extends StatefulWidget {
  const SalesApiPage({super.key, this.searchQuery = ''});

  final String searchQuery;

  @override
  State<SalesApiPage> createState() => _SalesApiPageState();
}

class _SalesApiPageState extends State<SalesApiPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<SalesCubit>();
    if (cubit.state.status == SalesStatus.initial) {
      cubit.loadSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null &&
          current.sales.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
        final filteredSales = _filterSales(state.sales);
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VENTAS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.searchQuery.isEmpty
                          ? 'Mostrando ${state.sales.length} de ${state.total} ventas'
                          : '${filteredSales.length} resultado(s) para "${widget.searchQuery}"',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildContent(context, state, filteredSales)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    SalesState state,
    List<Sale> filteredSales,
  ) {
    if (state.status == SalesStatus.loading && state.sales.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == SalesStatus.failure && state.sales.isEmpty) {
      return _SalesMessage(
        message: state.errorMessage ?? 'No fue posible cargar las ventas',
        buttonLabel: 'Reintentar',
        onPressed: () => context.read<SalesCubit>().loadSales(refresh: true),
      );
    }

    if (state.sales.isEmpty) {
      return _SalesMessage(
        message: 'No hay ventas registradas',
        buttonLabel: 'Actualizar',
        onPressed: () => context.read<SalesCubit>().loadSales(refresh: true),
      );
    }

    if (filteredSales.isEmpty) {
      return const _SalesMessage(
        message: 'No se encontraron ventas con ese criterio',
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SalesCubit>().loadSales(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount:
            filteredSales.length +
            (widget.searchQuery.isEmpty && state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filteredSales.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isLoadingMore
                      ? null
                      : () => context.read<SalesCubit>().loadSales(),
                  child: state.isLoadingMore
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Ver más...'),
                ),
              ),
            );
          }

          final summary = filteredSales[index];
          final sale = state.details[summary.id] ?? summary;
          return _SaleCardAdapter(
            sale: sale,
            isLoadingDetail: state.loadingDetailIds.contains(sale.id),
            detailError: state.detailErrors[sale.id],
            onLoadDetail: () => context.read<SalesCubit>().loadDetail(sale.id),
          );
        },
      ),
    );
  }

  List<Sale> _filterSales(List<Sale> sales) {
    final query = widget.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return sales;
    return sales
        .where((sale) {
          final fields = [
            sale.id.toString(),
            sale.customerName,
            sale.employeeName,
            sale.statusName,
            sale.paymentMethodsLabel,
          ];
          return fields.any((field) => field.toLowerCase().contains(query));
        })
        .toList(growable: false);
  }
}

class _SaleCardAdapter extends StatelessWidget {
  const _SaleCardAdapter({
    required this.sale,
    required this.isLoadingDetail,
    required this.onLoadDetail,
    this.detailError,
  });

  final Sale sale;
  final bool isLoadingDetail;
  final String? detailError;
  final Future<void> Function() onLoadDetail;

  @override
  Widget build(BuildContext context) {
    return VentaCard(
      numeroVenta: 'Venta #${sale.id}',
      estado: _mapStatus(sale.statusName),
      cliente: sale.customerName,
      vendedor: sale.employeeName,
      fecha: _formatDate(sale.date),
      metodoPago: sale.paymentMethodsLabel,
      total: sale.total,
      subtotal: sale.subtotal,
      iva: sale.ivaAmount,
      productos: sale.products
          .map(
            (product) => ProductoDetalle(
              nombre: product.name,
              descripcion: product.description,
              cantidad: product.quantity,
              valorUnitario: product.unitPrice,
              total: product.total,
            ),
          )
          .toList(growable: false),
      isLoadingDetail: isLoadingDetail,
      detailError: detailError,
      onLoadDetail: onLoadDetail,
    );
  }

  EstadoVenta _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'aprobada':
        return EstadoVenta.aprobada;
      case 'anulada':
        return EstadoVenta.anulada;
      case 'esperando aprobación':
      case 'pendiente':
        return EstadoVenta.espAprobacion;
      default:
        return EstadoVenta.desaprobada;
    }
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
  }
}

class _SalesMessage extends StatelessWidget {
  const _SalesMessage({
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onPressed != null && buttonLabel != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onPressed, child: Text(buttonLabel!)),
          ],
        ],
      ),
    );
  }
}
