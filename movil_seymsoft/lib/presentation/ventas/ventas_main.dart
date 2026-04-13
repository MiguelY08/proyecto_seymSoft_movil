// ventas_main.dart

import 'widgets/header.dart';
import 'widgets/menu.dart';
import 'widgets/menu_tab.dart';
import 'widgets/venta_card.dart';
import 'pages/ventas_page.dart';
import 'package:flutter/material.dart';

// — Entry point ejecutable
void main() {
  runApp(const VentasApp());
}

class VentasApp extends StatelessWidget {
  const VentasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VentasMain(),
    );
  }
}

// — Orquestador del módulo
class VentasMain extends StatefulWidget {
  const VentasMain({super.key});

  @override
  State<VentasMain> createState() => _VentasMainState();
}

class _VentasMainState extends State<VentasMain> {
  MenuTab _tabActivo = MenuTab.ventas;

  // — Data de prueba actualizada con productos, subtotal e IVA
  final List<VentaModel> _ventas = [
    // Venta 1 (con productos reales)
    VentaModel(
      numeroVenta: '382749105',
      estado: EstadoVenta.aprobada,
      cliente: 'Diana Patricia Herrera Ríos',
      fecha: '05/01/2025',
      metodoPago: 'Efectivo',
      vendedor: 'Laura Milena Restrepo',
      productos: [
        ProductoDetalle(
          nombre: 'Libreta con lapicero',
          descripcion: '2 PD > 2 azul, 1 roja',
          cantidad: 3,
          valorUnitario: 5000,
          total: 15000,
        ),
        ProductoDetalle(
          nombre: 'Bolígrafo Kilométrico x12',
          descripcion: '-',
          cantidad: 2,
          valorUnitario: 8400,
          total: 16800,
        ),
      ],
      subtotal: 31800,
      iva: 6042,
      total: 37842,
    ),
    // Venta 2
    VentaModel(
      numeroVenta: '519203847',
      estado: EstadoVenta.aprobada,
      cliente: 'Sebastián Felipe Agudelo Torres',
      vendedor: 'Carlos Andrés Muñoz',
      fecha: '10/01/2025',
      metodoPago: 'Transferencia',
      productos: [
        ProductoDetalle(
          nombre: 'Monitor 24"',
          descripcion: 'LED Full HD',
          cantidad: 2,
          valorUnitario: 75000,
          total: 150000,
        ),
        ProductoDetalle(
          nombre: 'Teclado mecánico',
          descripcion: 'Switch rojo',
          cantidad: 1,
          valorUnitario: 23145,
          total: 23145,
        ),
      ],
      subtotal: 173145,
      iva: 0,
      total: 173145,
    ),
    // Venta 3
    VentaModel(
      numeroVenta: '293847561',
      estado: EstadoVenta.anulada,
      cliente: 'Valentina Morales Fuentes',
      vendedor: 'Laura Milena Restrepo',
      fecha: '20/01/2025',
      metodoPago: 'Efectivo',
      productos: [
        ProductoDetalle(
          nombre: 'Cuaderno espiral',
          descripcion: '100 hojas',
          cantidad: 5,
          valorUnitario: 4200,
          total: 21000,
        ),
        ProductoDetalle(
          nombre: 'Lápiz HB',
          descripcion: 'Caja x12',
          cantidad: 2,
          valorUnitario: 3661,
          total: 7322,
        ),
      ],
      subtotal: 28322,
      iva: 0,
      total: 28322,
    ),
    // Venta 4
    VentaModel(
      numeroVenta: '847392015',
      estado: EstadoVenta.espAprobacion,
      cliente: 'Miguel Ángel Pérez Castañeda',
      vendedor: 'Isabella Chen Rodríguez',
      fecha: '25/01/2025',
      metodoPago: 'Transferencia',
      productos: [
        ProductoDetalle(
          nombre: 'Laptop 14"',
          descripcion: '16GB RAM, 512GB SSD',
          cantidad: 1,
          valorUnitario: 204400,
          total: 204400,
        ),
        ProductoDetalle(
          nombre: 'Mouse inalámbrico',
          descripcion: 'Logitech',
          cantidad: 1,
          valorUnitario: 38836,
          total: 38836,
        ),
      ],
      subtotal: 243236,
      iva: 0,
      total: 243236,
    ),
    // Venta 5
    VentaModel(
      numeroVenta: '560294817',
      estado: EstadoVenta.desaprobada,
      cliente: 'Santiago Alejandro Ruiz Patiño',
      vendedor: 'Usuario eliminado',
      fecha: '07/02/2025',
      metodoPago: 'Crédito',
      productos: [
        ProductoDetalle(
          nombre: 'Silla ergonómica',
          descripcion: 'Color negro',
          cantidad: 1,
          valorUnitario: 88298,
          total: 88298,
        ),
      ],
      subtotal: 88298,
      iva: 0,
      total: 88298,
    ),
  ];

  Widget _buildBody() {
    switch (_tabActivo) {
      case MenuTab.ventas:
        return VentasPage(ventas: _ventas);
      case MenuTab.inicio:
      case MenuTab.compras:
      case MenuTab.ajustes:
        return const _PlaceholderView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // — Header
            VentasHeader(
              nombreUsuario: 'Sebastian B',
              rol: 'Administrador',
              onSearch: () {},
              onNotifications: () {},
            ),

            // — Contenido según tab activo
            Expanded(child: _buildBody()),

            // — Menú inferior
            VentasMenu(
              tabActivo: _tabActivo,
              onTabSeleccionado: (tab) {
                setState(() => _tabActivo = tab);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// — Placeholder para tabs no implementados
class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Próximamente',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}