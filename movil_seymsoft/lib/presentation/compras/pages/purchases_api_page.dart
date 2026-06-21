import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/purchases_cubit.dart';
import '../widgets/purchase_api_card.dart';

class PurchasesApiPage extends StatefulWidget {
  const PurchasesApiPage({super.key});

  @override
  State<PurchasesApiPage> createState() => _PurchasesApiPageState();
}

class _PurchasesApiPageState extends State<PurchasesApiPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PurchasesCubit>();
    if (cubit.state.status == PurchasesStatus.initial) {
      cubit.loadPurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchasesCubit, PurchasesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null &&
          current.purchases.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
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
                      'COMPRAS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mostrando ${state.purchases.length} de '
                      '${state.total} compras',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PurchasesState state) {
    if (state.status == PurchasesStatus.loading && state.purchases.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == PurchasesStatus.failure && state.purchases.isEmpty) {
      return _Message(
        text: state.errorMessage ?? 'No fue posible cargar las compras',
        onPressed: () =>
            context.read<PurchasesCubit>().loadPurchases(refresh: true),
      );
    }
    if (state.purchases.isEmpty) {
      return _Message(
        text: 'No hay compras registradas',
        onPressed: () =>
            context.read<PurchasesCubit>().loadPurchases(refresh: true),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<PurchasesCubit>().loadPurchases(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: state.purchases.length + (state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.purchases.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isLoadingMore
                      ? null
                      : () => context.read<PurchasesCubit>().loadPurchases(),
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

          final summary = state.purchases[index];
          final purchase = state.details[summary.id] ?? summary;
          final detailQuantity = purchase.details.fold<int>(
            0,
            (total, item) => total + item.quantity,
          );
          final quantity = purchase.totalQuantity > 0
              ? purchase.totalQuantity
              : detailQuantity;

          return PurchaseApiCard(
            provider: purchase.providerName,
            invoiceNumber: purchase.invoiceNumber,
            quantity: quantity,
            date: _formatDate(purchase.purchaseDate),
            total: _money(purchase.totalAmount),
            status: purchase.status,
            details: purchase.details,
            isLoadingDetail: state.loadingDetailIds.contains(purchase.id),
            detailError: state.detailErrors[purchase.id],
            onLoadDetail: () =>
                context.read<PurchasesCubit>().loadDetail(purchase.id),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
  }

  String _money(double value) {
    final digits = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[index]);
    }
    return '\$ $buffer';
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onPressed, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
