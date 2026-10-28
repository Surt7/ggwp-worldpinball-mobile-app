import 'package:flutter/material.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../../../qr_code/presentation/qr_pass_screen.dart';
import '../../../settings/presentation/settings_bottom_sheet.dart';

/// Reusable arcade-themed bottom navigation bar for World Pinball.
class MainBottomBar extends StatelessWidget {
  final VoidCallback onLogout;

  const MainBottomBar({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12.0),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.grey),
              tooltip: 'Déconnexion',
              onPressed: () => showLogoutDialog(context, onLogout: onLogout),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const QrPassScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.qr_code_2, size: 28),
                label: const Text(
                  'SCAN PASS (QR CODE)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              tooltip: 'Paramètres',
              onPressed: () => showSettingsBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
