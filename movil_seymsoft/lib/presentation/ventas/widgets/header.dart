import 'package:flutter/material.dart';

class VentasHeader extends StatelessWidget {
  final String nombreUsuario;
  final String rol;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  const VentasHeader({
    super.key,
    required this.nombreUsuario,
    required this.rol,
    required this.onSearch,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreUsuario,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rol,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
          IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications)),
        ],
      ),
    );
  }
}
