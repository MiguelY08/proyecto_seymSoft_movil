// compras_page.dart

import 'package:flutter/material.dart';
import '../widgets/compra_card.dart';

class ComprasPage extends StatelessWidget {
  final List<CompraModel> compras;

  const ComprasPage({
    super.key,
    required this.compras,
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
                  'COMPRAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mostrando ${compras.length} de ${compras.length} compras',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // — Lista de cards + botón Ver Más
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: compras.length + 1, // — +1 para el botón al final
              itemBuilder: (context, index) {
                // — Último ítem: botón Ver Más
                if (index == compras.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: implementar paginación
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3A6B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Ver Más...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // — Cards normales
                final compra = compras[index];
                return CompraCard(
                  proveedor: compra.proveedor,
                  nroFactura: compra.nroFactura,
                  cantidadProductos: compra.cantidadProductos,
                  fecha: compra.fecha,
                  total: compra.total,
                  completada: compra.completada,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// — Modelo de datos
class CompraModel {
  final String proveedor;
  final String nroFactura;
  final String cantidadProductos;
  final String fecha;
  final String total;
  final bool completada;

  const CompraModel({
    required this.proveedor,
    required this.nroFactura,
    required this.cantidadProductos,
    required this.fecha,
    required this.total,
    required this.completada,
  });
}