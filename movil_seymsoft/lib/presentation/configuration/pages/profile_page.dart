import 'package:flutter/material.dart';
import '../widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Column(
        children: [

          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A5F),
            ),
            child: const Center(
              child: Text(
                "AJUSTES",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 👤 PERFIL
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // FOTO + NOMBRE
                Column(
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage("assets/images/profile.jpg"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Emmanuel Muñoz",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Administrador",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // DATOS
                const ProfileItem(
                  icon: Icons.email,
                  title: "Correo",
                  value: "admin@seymsoft.com",
                ),

                const ProfileItem(
                  icon: Icons.phone,
                  title: "Teléfono",
                  value: "+57 300 123 4567",
                ),

                const ProfileItem(
                  icon: Icons.business,
                  title: "Negocio",
                  value: "SeymSoft",
                ),

                const ProfileItem(
                  icon: Icons.location_on,
                  title: "Dirección",
                  value: "Medellín, Colombia",
                ),

                const SizedBox(height: 30),

                // 🚪 BOTÓN CERRAR SESIÓN — estilo sutil
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[400],
                    side: BorderSide(color: Colors.red[300]!, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.red[50],
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}