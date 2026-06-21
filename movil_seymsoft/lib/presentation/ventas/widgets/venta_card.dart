// venta_card.dart

import 'package:flutter/material.dart';
import 'ventas_details.dart';
import '../pages/ventas_page.dart';

enum EstadoVenta { aprobada, anulada, espAprobacion, desaprobada }

class VentaCard extends StatefulWidget {
  final String numeroVenta;
  final EstadoVenta estado;
  final String cliente;
  final String? vendedor;
  final String fecha;
  final String metodoPago;
  final double total;
  final List<ProductoDetalle> productos;
  final double subtotal;
  final double iva;
  final bool isLoadingDetail;
  final String? detailError;
  final Future<void> Function()? onLoadDetail;

  const VentaCard({
    super.key,
    required this.numeroVenta,
    required this.estado,
    required this.cliente,
    this.vendedor,
    required this.fecha,
    required this.metodoPago,
    required this.total,
    required this.productos,
    required this.subtotal,
    required this.iva,
    this.isLoadingDetail = false,
    this.detailError,
    this.onLoadDetail,
  });

  @override
  State<VentaCard> createState() => _VentaCardState();
}

class _VentaCardState extends State<VentaCard> {
  bool _expanded = false;

  Future<void> _toggleExpand() async {
    setState(() {
      _expanded = !_expanded;
    });
    if (_expanded && widget.productos.isEmpty) {
      await widget.onLoadDetail?.call();
    }
  }

  _BadgeConfig _getBadgeConfig() {
    switch (widget.estado) {
      case EstadoVenta.aprobada:
        return _BadgeConfig(
          'APROBADA',
          const Color(0xFF2E7D32),
          const Color(0xFFE8F5E9),
        );
      case EstadoVenta.anulada:
        return _BadgeConfig(
          'ANULADA',
          const Color(0xFFC62828),
          const Color(0xFFFFEBEE),
        );
      case EstadoVenta.espAprobacion:
        return _BadgeConfig(
          'ESP. APROBACIÓN',
          const Color(0xFFE65100),
          const Color(0xFFFFF3E0),
        );
      case EstadoVenta.desaprobada:
        return _BadgeConfig(
          'DESAPROBADA',
          const Color(0xFFC62828),
          const Color(0xFFFFEBEE),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _getBadgeConfig();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Fila superior: número + badge + chevron
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.numeroVenta,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badge.bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badge.textColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleExpand,
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
                          size: 20,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // — Fila: Cliente (y Vendedor si existe)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoField(label: 'Cliente', value: widget.cliente),
                ),
                if (widget.vendedor != null)
                  Expanded(
                    child: _InfoField(
                      label: 'Vendedor',
                      value: widget.vendedor!,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // — Fila: Fecha + Método Pago
            Row(
              children: [
                Expanded(
                  child: _InfoField(label: 'Fecha', value: widget.fecha),
                ),
                Expanded(
                  child: _InfoField(
                    label: 'Método Pago',
                    value: widget.metodoPago,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            const SizedBox(height: 12),

            // — Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9E9E9E),
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '\$ ${_formatTotal(widget.total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),

            // — Detalle expandido
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
                _DetailError(
                  message: widget.detailError!,
                  onRetry: widget.onLoadDetail,
                )
              else
                VentaDetails(
                  venta: VentaModel(
                    numeroVenta: widget.numeroVenta,
                    estado: widget.estado,
                    cliente: widget.cliente,
                    vendedor: widget.vendedor,
                    fecha: widget.fecha,
                    metodoPago: widget.metodoPago,
                    total: widget.total,
                    productos: widget.productos,
                    subtotal: widget.subtotal,
                    iva: widget.iva,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTotal(double value) {
    final parts = value.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }
}

// — Widget auxiliar para campos label/value
class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// — Config interna para badges
class _BadgeConfig {
  final String label;
  final Color textColor;
  final Color bgColor;
  const _BadgeConfig(this.label, this.textColor, this.bgColor);
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, this.onRetry});

  final String message;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        TextButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    );
  }
}
