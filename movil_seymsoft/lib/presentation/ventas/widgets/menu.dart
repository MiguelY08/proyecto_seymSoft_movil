import 'package:flutter/material.dart';
import 'menu_tab.dart';

class VentasMenu extends StatelessWidget {
  final MenuTab tabActivo;
  final ValueChanged<MenuTab> onTabSeleccionado;

  const VentasMenu({
    super.key,
    required this.tabActivo,
    required this.onTabSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'INICIO',
            icon: Icons.home_outlined,
            selected: tabActivo == MenuTab.inicio,
            onTap: () => onTabSeleccionado(MenuTab.inicio),
          ),
          _NavItem(
            label: 'VENTAS',
            icon: Icons.show_chart_outlined,
            selected: tabActivo == MenuTab.ventas,
            onTap: () => onTabSeleccionado(MenuTab.ventas),
          ),
          _NavItem(
            label: 'COMPRAS',
            icon: Icons.shopping_bag_outlined,
            selected: tabActivo == MenuTab.compras,
            onTap: () => onTabSeleccionado(MenuTab.compras),
          ),
          _NavItem(
            label: 'AJUSTES',
            icon: Icons.settings_outlined,
            selected: tabActivo == MenuTab.ajustes,
            onTap: () => onTabSeleccionado(MenuTab.ajustes),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: selected ? const Color(0xFF1E3A5F) : const Color(0xFF9E9E9E)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: selected ? const Color(0xFF1E3A5F) : const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
