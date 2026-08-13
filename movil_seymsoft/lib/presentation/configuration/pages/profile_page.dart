import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/company_constants.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final profile = authState.profile;
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Column(
        children: [
          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(color: Color(0xFF1E3A5F)),
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
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE3EAF2),
                      child: Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile?.user.fullName ?? 'Administrador',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      profile?.role.name ?? 'Administrator',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // DATOS
                ProfileItem(
                  icon: Icons.email,
                  title: "Correo",
                  value: profile?.user.email ?? 'Sin correo',
                ),

                ProfileItem(
                  icon: Icons.phone,
                  title: "Teléfono",
                  value: profile?.user.phone ?? 'Sin teléfono',
                ),

                const ProfileItem(
                  icon: Icons.business,
                  title: "Empresa",
                  value: CompanyConstants.name,
                ),

                const ProfileItem(
                  icon: Icons.location_on,
                  title: "Dirección",
                  value:
                      "${CompanyConstants.address}\n"
                      "${CompanyConstants.location}\n"
                      "${CompanyConstants.city}",
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
                  onPressed: isLoading
                      ? null
                      : () => context.read<AuthCubit>().logout(),
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout, size: 18),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
