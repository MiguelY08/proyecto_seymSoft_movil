// ventas_page.dart

import 'package:flutter/material.dart';
import '../widgets/venta_card.dart';

/// Modelo para un producto dentro de una venta
class ProductoDetalle {
  final String nombre;
  final String descripcion;
  final int cantidad;
  final double valorUnitario;
  final double total;

  const ProductoDetalle({
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.valorUnitario,
    required this.total,
  });
}

/// Modelo completo de una venta
class VentaModel {
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

  const VentaModel({
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
  });
}

class VentasPage extends StatelessWidget {
  final List<VentaModel> ventas;

  const VentasPage({
    super.key,
    required this.ventas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — Título y subtítulo
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
                  'Mostrando ${ventas.length} de ${ventas.length} ventas',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // — Lista de cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: ventas.length,
              itemBuilder: (context, index) {
                final venta = ventas[index];
                return VentaCard(
                  numeroVenta: venta.numeroVenta,
                  estado: venta.estado,
                  cliente: venta.cliente,
                  vendedor: venta.vendedor,
                  fecha: venta.fecha,
                  metodoPago: venta.metodoPago,
                  total: venta.total,
                  productos: venta.productos,
                  subtotal: venta.subtotal,
                  iva: venta.iva,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}