import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 14),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF00ACC1)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFE3F2FD), width: 2),
            ),
            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sebastian B',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                Text('Administrador',
                    style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: Color(0xFF1A1A2E), size: 24),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1A1A2E), size: 24),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}