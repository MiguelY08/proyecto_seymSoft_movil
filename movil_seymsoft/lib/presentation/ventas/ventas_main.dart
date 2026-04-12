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

  // — Data de prueba basada en las capturas
  final List<VentaModel> _ventas = const [
    VentaModel(
      numeroVenta: '382749105',
      estado: EstadoVenta.aprobada,
      cliente: 'Diana Patricia Herrera Ríos',
      fecha: '05/01/2025',
      metodoPago: 'Efectivo',
      total: 37842,
    ),
    VentaModel(
      numeroVenta: '519203847',
      estado: EstadoVenta.aprobada,
      cliente: 'Sebastián Felipe Agudelo Torres',
      vendedor: 'Carlos Andrés Muñoz',
      fecha: '10/01/2025',
      metodoPago: 'Transferencia',
      total: 173145,
    ),
    VentaModel(
      numeroVenta: '293847561',
      estado: EstadoVenta.anulada,
      cliente: 'Valentina Morales Fuentes',
      vendedor: 'Laura Milena Restrepo',
      fecha: '20/01/2025',
      metodoPago: 'Efectivo',
      total: 28322,
    ),
    VentaModel(
      numeroVenta: '847392015',
      estado: EstadoVenta.espAprobacion,
      cliente: 'Miguel Ángel Pérez Castañeda',
      vendedor: 'Isabella Chen Rodríguez',
      fecha: '25/01/2025',
      metodoPago: 'Transferencia',
      total: 243236,
    ),
    VentaModel(
      numeroVenta: '560294817',
      estado: EstadoVenta.desaprobada,
      cliente: 'Santiago Alejandro Ruiz Patiño',
      vendedor: 'Usuario eliminado',
      fecha: '07/02/2025',
      metodoPago: 'Crédito',
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