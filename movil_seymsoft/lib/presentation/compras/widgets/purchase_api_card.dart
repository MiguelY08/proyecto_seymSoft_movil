import 'package:flutter/material.dart';

import '../../../data/models/purchase_models.dart';

class PurchaseApiCard extends StatefulWidget {
  const PurchaseApiCard({
    super.key,
    required this.provider,
    required this.invoiceNumber,
    required this.quantity,
    required this.date,
    required this.total,
    required this.status,
    required this.details,
    this.isLoadingDetail = false,
    this.detailError,
    this.onLoadDetail,
  });

  final String provider;
  final String invoiceNumber;
  final int quantity;
  final String date;
  final String total;
  final String status;
  final List<PurchaseProduct> details;
  final bool isLoadingDetail;
  final String? detailError;
  final Future<void> Function()? onLoadDetail;

  @override
  State<PurchaseApiCard> createState() => _PurchaseApiCardState();
}

class _PurchaseApiCardState extends State<PurchaseApiCard> {
  bool _expanded = false;

  Future<void> _toggleExpanded() async {
    setState(() => _expanded = !_expanded);
    if (_expanded && widget.details.isEmpty) {
      await widget.onLoadDetail?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = widget.status.toLowerCase() == 'completada';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.provider,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: completed
                      ? const Color(0xFFD4EDDA)
                      : const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: completed
                        ? const Color(0xFF28A745)
                        : const Color(0xFFDC3545),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _toggleExpanded,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoField(
                  label: 'Nro. Factura',
                  value: widget.invoiceNumber,
                ),
              ),
              Expanded(
                child: _InfoField(
                  label: 'Cantidad de productos',
                  value: '${widget.quantity}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoField(label: 'Fecha', value: widget.date),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE5E5EA)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
              ),
              Text(
                widget.total,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 16),
            if (widget.isLoadingDetail)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (widget.detailError != null)
              Column(
                children: [
                  Text(
                    widget.detailError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: widget.onLoadDetail,
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            else
              _PurchaseDetails(products: widget.details),
          ],
        ],
      ),
    );
  }
}

class _PurchaseDetails extends StatelessWidget {
  const _PurchaseDetails({required this.products});

  final List<PurchaseProduct> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRODUCTOS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(height: 12),
        ...products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  'Código: ${product.barcode} · Lote: ${product.batchCode}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoField(
                        label: 'Cantidad',
                        value: '${product.quantity}',
                      ),
                    ),
                    Expanded(
                      child: _InfoField(
                        label: 'Valor unitario',
                        value: _money(product.netUnitPrice),
                      ),
                    ),
                    Expanded(
                      child: _InfoField(
                        label: 'Subtotal',
                        value: _money(product.netSubtotal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Base: ${_money(product.grossSubtotal)} · '
                  'IVA ${product.taxPercentage.toStringAsFixed(0)}%: '
                  '${_money(product.ivaSubtotal)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ],
    );
  }
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
