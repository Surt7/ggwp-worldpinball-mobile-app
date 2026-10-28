import 'package:flutter/material.dart';
import 'qr_pass_screen.dart';
import 'widgets/camera_scanner_dialog.dart';
import 'widgets/manual_session_code_dialog.dart';

// Modal bottom sheet presenting the 3 ways to join an arcade pinball session
class JoinGameBottomSheet extends StatelessWidget {
  const JoinGameBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle indicator
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header title and close action
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE53935)),
                  ),
                  child: const Icon(
                    Icons.sports_esports,
                    color: Color(0xFFE53935),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REJOINDRE UNE PARTIE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'Connectez votre profil joueur au flipper',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Option 1: Scan cabinet LCD screen with phone camera
            _buildOptionCard(
              context: context,
              icon: Icons.qr_code_scanner,
              accentColor: const Color(0xFFE53935),
              title: 'SCANNER L\'ÉCRAN DU FLIPPER',
              badge: 'Caméra smartphone',
              subtitle:
                  'Pointez l\'appareil photo de votre téléphone vers le QR Code affiché sur l\'écran LCD du flipper.',
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const CameraScannerDialog(),
                );
              },
            ),

            const SizedBox(height: 12),

            // Option 2: Enter session or cabinet code manually
            _buildOptionCard(
              context: context,
              icon: Icons.pin,
              accentColor: const Color(0xFF00E5FF),
              title: 'SAISIR LE CODE DE SESSION',
              badge: 'Valable 24h',
              subtitle:
                  'Entrez le code à 6 chiffres affiché sur le flipper ou photographié lors de votre partie.',
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const ManualSessionCodeDialog(),
                );
              },
            ),

            const SizedBox(height: 12),

            // Option 3: Optical Player Pass (retained for cabinets with built-in cameras)
            _buildOptionCard(
              context: context,
              icon: Icons.qr_code_2,
              accentColor: const Color(0xFF76FF03),
              title: 'MON PASS JOUEUR (QR CODE)',
              badge: 'Lecteur flipper',
              subtitle:
                  'Affichez votre QR Code personnel si le flipper dispose d\'un lecteur optique intégré.',
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const QrPassScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder for arcade-themed action cards
  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color accentColor,
    required String title,
    required String badge,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
