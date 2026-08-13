// ventas_details.dart

import 'package:flutter/material.dart';
import '../pages/ventas_page.dart'; // Importa VentaModel y ProductoDetalle

/// Widget que muestra el detalle expandido de una venta
class VentaDetails extends StatelessWidget {
  final VentaModel venta;

  const VentaDetails({super.key, required this.venta});

  String _formatMoneda(double valor) {
    final parts = valor.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return '\$ $buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E9EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — Lista de productos
          const Text(
            'PRODUCTOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: venta.productos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final producto = venta.productos[index];
              return _ProductoItem(producto: producto);
            },
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // — Vendedor (si existe)
          if (venta.vendedor != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              label: 'VENDEDOR',
              value: venta.vendedor!,
              valueStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
          ],

          // — Subtotal, IVA y Total
          const SizedBox(height: 12),
          _InfoRow(
            label: 'SUBTOTAL',
            value: _formatMoneda(venta.subtotal),
            valueStyle: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'IVA',
            value: _formatMoneda(venta.iva),
            valueStyle: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'TOTAL',
            value: _formatMoneda(venta.total),
            valueStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget interno para mostrar un producto individual
class _ProductoItem extends StatelessWidget {
  final ProductoDetalle producto;

  const _ProductoItem({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E7ED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            producto.nombre,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (producto.descripcion.isNotEmpty && producto.descripcion != '-')
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                producto.descripcion,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _InfoField(
                  label: 'Cantidad',
                  value: '${producto.cantidad}',
                ),
              ),
              Expanded(
                flex: 3,
                child: _InfoField(
                  label: 'Valor Unitario',
                  value: _formatMoneda(producto.valorUnitario),
                ),
              ),
              Expanded(
                flex: 2,
                child: _InfoField(
                  label: 'Total',
                  value: _formatMoneda(producto.total),
                  isBold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMoneda(double valor) {
    final parts = valor.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return '\$ $buffer';
  }
}

/// Widget auxiliar para mostrar una fila de información (label + valor)
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
            letterSpacing: 0.8,
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
        ),
      ],
    );
  }
}

/// Widget auxiliar para campos dentro de un producto
class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoField({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
