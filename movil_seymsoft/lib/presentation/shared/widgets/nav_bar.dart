import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../routes.dart';
import '../../dashboard/pages/dashboard.dart';
import '../../ventas/pages/sales_api_page.dart';
import '../../ventas/pages/ventas_page.dart';
import '../../compras/pages/purchases_api_page.dart';
import '../../compras/pages/compras_pages.dart';
import '../../ventas/widgets/venta_card.dart';
import 'header.dart';
import '../../../presentation/configuration/pages/profile_page.dart';
import '../../auth/cubit/auth_cubit.dart';

// ─────────────────────────────────────────────
// CONSTANTES DE RUTAS
// Centralizar los nombres de ruta evita errores
// de tipeo y facilita el mantenimiento.
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// MODELO DE ÍTEM DE NAVEGACIÓN
// Encapsula la información de cada pestaña:
// ícono, etiqueta y ruta destino.
// ─────────────────────────────────────────────

/// [NavItem] es un objeto de datos (modelo) que describe
/// cada elemento de la barra de navegación inferior.
class NavItem {
  /// Ícono que se muestra debajo de la etiqueta
  final IconData icon;

  /// Texto visible bajo el ícono
  final String label;

  /// Ruta nombrada a la que navega este ítem
  final String route;

  const NavItem({required this.icon, required this.label, required this.route});
}

// ─────────────────────────────────────────────
// SCAFFOLD PRINCIPAL
// Mantiene el índice seleccionado y renderiza
// la pantalla activa junto con la barra inferior.
// ─────────────────────────────────────────────

/// [MainScaffold] es el contenedor principal de la app.
///
/// Gestiona:
/// - El índice de la pestaña activa.
/// - La lista de destinos de navegación.
/// - El intercambio de pantallas al tocar un ítem.
///
/// Usa [StatefulWidget] porque necesita recordar
/// qué pestaña está seleccionada entre rebuilds.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // Índice de la pestaña actualmente seleccionada.
  // 0 = Inicio, 1 = Ventas, 2 = Compras, 3 = Ajustes
  int _selectedIndex = 0;

  // Datos de ventas
  // TODO: eliminar estos datos de demostración cuando se retiren los entrypoints
  // independientes del módulo de ventas.
  // ignore: unused_field
  final List<VentaModel> _ventas = [
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

  // Datos de compras
  // TODO: eliminar estos datos de demostración cuando se retiren los entrypoints
  // independientes del módulo de compras.
  // ignore: unused_field
  final List<CompraModel> _compras = [
    CompraModel(
      proveedor: 'Papelería el punto escolar',
      nroFactura: '12345455',
      cantidadProductos: '8',
      fecha: '05/03/2025',
      total: '\$ 1.000.000',
      completada: true,
    ),
    CompraModel(
      proveedor: 'Ofiexpress Ltda.',
      nroFactura: '765432111',
      cantidadProductos: '5',
      fecha: '05/02/2025',
      total: '\$ 300.000',
      completada: false,
    ),
    CompraModel(
      proveedor: 'Papelería el punto escolar',
      nroFactura: '12345421',
      cantidadProductos: '8',
      fecha: '05/01/2025',
      total: '\$ 1.000.000',
      completada: true,
    ),
    CompraModel(
      proveedor: 'Arte color suppliers',
      nroFactura: '92395421',
      cantidadProductos: '9',
      fecha: '05/01/2025',
      total: '\$ 3.000.000',
      completada: false,
    ),
  ];

  /// Lista de pantallas en el mismo orden que los ítems del menú.
  List<Widget> get _screens => [
    const DashboardScreen(),
    const SalesApiPage(),
    const PurchasesApiPage(),
    const ProfilePage(),
  ];

  /// Definición de los ítems de navegación.
  /// El orden aquí debe coincidir con [_screens].
  static const List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      label: 'INICIO',
      route: AppRoutes.inicio,
    ),
    NavItem(
      icon: Icons.show_chart_outlined,
      label: 'VENTAS',
      route: AppRoutes.ventas,
    ),
    NavItem(
      icon: Icons.shopping_bag_outlined,
      label: 'COMPRAS',
      route: AppRoutes.compras,
    ),
    NavItem(
      icon: Icons.settings_outlined,
      label: 'AJUSTES',
      route: AppRoutes.ajustes,
    ),
  ];

  /// Callback que se invoca cuando el usuario toca un ítem.
  /// Actualiza [_selectedIndex] para disparar un rebuild
  /// y mostrar la pantalla correcta.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthCubit>().state.profile;

    return Scaffold(
      // Encabezado común con nombre, rol y accesos rápidos
      body: Column(
        children: [
          VentasHeader(
            nombreUsuario: profile?.user.fullName ?? 'Administrador',
            rol: profile?.role.name ?? 'Administrator',
            onSearch: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Buscar - Próximamente')),
              );
            },
            onNotifications: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificaciones - Próximamente')),
              );
            },
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),

      // La barra de navegación inferior personalizada
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        navItems: _navItems,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BARRA DE NAVEGACIÓN INFERIOR
// Widget presentacional puro: recibe datos y
// callbacks — no maneja estado interno.
// ─────────────────────────────────────────────

/// [AppBottomNavBar] renderiza la barra de navegación
/// inferior con el estilo fiel a la imagen de referencia:
///
/// - Fondo blanco con sombra sutil en la parte superior.
/// - Ítem activo en azul oscuro (#1E3A5F) con texto en bold.
/// - Ítems inactivos en gris (#9E9E9E).
/// - Separador superior azul oscuro para el ítem activo.
///
/// Es un [StatelessWidget] porque no posee estado propio;
/// toda la lógica de selección vive en [MainScaffold].
class AppBottomNavBar extends StatelessWidget {
  /// Índice del ítem actualmente activo
  final int selectedIndex;

  /// Lista de ítems a renderizar
  final List<NavItem> navItems;

  /// Función que se llama con el índice del ítem tocado
  final ValueChanged<int> onItemTapped;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onItemTapped,
  });

  // Colores extraídos de la imagen de referencia
  static const Color _activeColor = Color(0xFF1E3A5F); // Azul oscuro
  static const Color _inactiveColor = Color(0xFFBDBDBD); // Gris claro
  static const Color _barBackground = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sombra superior que separa la barra del contenido
      decoration: const BoxDecoration(
        color: _barBackground,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),

      // SafeArea respeta el home indicator en iPhones
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            // Distribuye los ítems uniformemente en el ancho
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) => _NavBarItem(
                item: navItems[index],
                isSelected: index == selectedIndex,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onItemTapped(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ÍTEM INDIVIDUAL DE LA BARRA
// Renderiza un solo botón: ícono + etiqueta,
// con el indicador superior cuando está activo.
// ─────────────────────────────────────────────

/// [_NavBarItem] representa un botón individual dentro
/// de la barra de navegación.
///
/// Cuando [isSelected] es true:
/// - Muestra una línea azul en la parte superior.
/// - Pinta ícono y texto en [activeColor].
/// - El texto aparece en negrita.
///
/// Cuando [isSelected] es false:
/// - Sin línea superior.
/// - Ícono y texto en [inactiveColor].
///
/// Es privado (prefijo `_`) porque solo lo usa [AppBottomNavBar].
class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Toda el área es tocable
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Indicador superior (línea azul en ítem activo) ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 40 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Ícono ──
            Icon(item.icon, size: 24, color: color),

            const SizedBox(height: 4),

            // ── Etiqueta de texto ──
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// PANTALLAS DE DESTINO
// Cada pantalla es un placeholder sencillo que
// muestra el nombre de la sección. En producción
// aquí iría el contenido real de cada módulo.
// ═════════════════════════════════════════════

/// [AjustesScreen] — Pantalla del módulo de Ajustes.
/// Configuración de cuenta, preferencias y parámetros del sistema.
class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(
      title: 'AJUSTES',
      icon: Icons.settings_outlined,
      color: Color(0xFF1E3A5F),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET PLACEHOLDER REUTILIZABLE
// Muestra ícono + título centrado. Usado por
// todas las pantallas destino mientras se
// desarrolla el contenido real de cada módulo.
// ─────────────────────────────────────────────

/// [_PlaceholderScreen] es un widget privado y reutilizable
/// que renderiza una pantalla vacía con ícono y título centrados.
///
/// Su propósito es servir como andamiaje (scaffold) mientras
/// se implementa el contenido real de cada módulo.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: color.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.4),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contenido en construcción',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
