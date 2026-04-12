import 'package:flutter/material.dart';

class CompraCard extends StatelessWidget {
  final String proveedor;
  final String nroFactura;
  final String cantidadProductos;
  final String fecha;
  final String total;
  final bool completada;

  const CompraCard({
    super.key,
    required this.proveedor,
    required this.nroFactura,
    required this.cantidadProductos,
    required this.fecha,
    required this.total,
    required this.completada,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Fila superior: proveedor + badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  proveedor,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: completada
                      ? const Color(0xFFD4EDDA)
                      : const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  completada ? 'COMPLETADA' : 'ANULADA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: completada
                        ? const Color(0xFF28A745)
                        : const Color(0xFFDC3545),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Fila: Nro. Factura | Cantidad de productos ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nro. Factura',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nroFactura,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cantidad de productos',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cantidadProductos,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Fecha ──
          const Text(
            'Fecha',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),
          const SizedBox(height: 12),

          // ── Total ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8E8E93),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                total,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}