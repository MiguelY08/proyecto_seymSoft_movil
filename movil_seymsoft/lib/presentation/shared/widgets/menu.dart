import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final int currentIndex;

  const Menu({super.key, this.currentIndex = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _MenuItem(
                icon: Icons.home_outlined,
                label: 'INICIO',
                isSelected: currentIndex == 0,
              ),
              _MenuItem(
                icon: Icons.show_chart,
                label: 'VENTAS',
                isSelected: currentIndex == 1,
              ),
              _MenuItem(
                icon: Icons.shopping_bag,
                label: 'COMPRAS',
                isSelected: currentIndex == 2,
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: 'AJUSTES',
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF1B3A6B);
    const Color inactiveColor = Color(0xFF8E8E93);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? activeColor : inactiveColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}