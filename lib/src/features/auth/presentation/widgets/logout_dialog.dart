import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';

/// Displays a confirmation dialog for logging out of Keycloak IAM.
void showLogoutDialog(BuildContext context, {required VoidCallback onLogout}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text('Déconnexion'),
      content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
          onPressed: () async {
            await AuthRepository().logout();
            if (context.mounted) {
              Navigator.pop(context);
              onLogout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Déconnecté de Keycloak avec succès.')),
              );
            }
          },
          child: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
