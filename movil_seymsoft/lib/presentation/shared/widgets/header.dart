// header.dart

import 'package:flutter/material.dart';

class VentasHeader extends StatelessWidget {
  final String nombreUsuario;
  final String rol;
  final VoidCallback? onSearch;
  final VoidCallback? onNotifications;

  const VentasHeader({
    super.key,
    required this.nombreUsuario,
    required this.rol,
    this.onSearch,
    this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // — Avatar
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFF1B4F72),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          // — Nombre y rol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombreUsuario,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rol,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),

          // — Botones acción
          _HeaderIconButton(
            icon: Icons.search_rounded,
            onTap: onSearch,
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotifications,
          ),
        ],
      ),
    );
  }
}

// — Botón icono reutilizable
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }
}