import 'package:flutter/material.dart';
import 'profile_page.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

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

          // 📋 OPCIONES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Perfil"),
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}