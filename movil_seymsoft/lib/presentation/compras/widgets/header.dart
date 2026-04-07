import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: topPadding + 10,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFF1B3A6B),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),

          const SizedBox(width: 10),

          // ── Nombre + Rol ──
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sebastian B',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              Text(
                'Administrador',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8E8E93),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Ícono búsqueda ──
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.search,
              color: Color(0xFF1C1C1E),
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          // ── Ícono notificación ──
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF1C1C1E),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}