import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_pinball_gg_wp/src/features/machines/presentation/machines_screen.dart';
import 'package:world_pinball_gg_wp/src/features/profile/presentaiton/profile_screen.dart';
import 'package:world_pinball_gg_wp/src/shared/config/security_config.dart';
import 'package:world_pinball_gg_wp/src/shared/theme/app_theme.dart';
import 'src/features/machines/data/machine_repository.dart';
import 'src/features/machines/bloc/machines_bloc.dart';
import 'src/features/machines/bloc/machines_event.dart';
import 'src/features/leaderboard/presentation/leaderboard_screen.dart';
import 'src/features/qr_code/presentation/qr_pass_screen.dart';
import 'src/features/scores/presentation/scores_screen.dart';
import 'src/features/auth/data/auth_repository.dart';

void main() {
  // In debug mode, verify certificates using the local WorldPinball Root CA and handle emulator routing.
  // In release mode (production), the OS natively validates the public TLS certificate.
  if (kDebugMode) {
    final securityContext = SecurityConfig.createSecurityContext();
    HttpOverrides.global = WorldPinballHttpOverrides(securityContext);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Pinball',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) => MachinesBloc(MachineRepository())..add(LoadMachinesEvent()),
        child: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
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

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PARAMÈTRES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: const Text('Langue'),
              trailing: const Text('Français 🇫🇷', style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.white),
              title: const Text('Thème'),
              trailing: const Text('Sombre (Red Pinball)', style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text('Version de l\'application'),
              trailing: const Text('1.0.0 (V1)', style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('World Pinball'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: Color(0xFFE53935),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(icon: Icon(Icons.leaderboard), text: 'Scores'),
              Tab(icon: Icon(Icons.videogame_asset), text: 'Machines'),
              Tab(icon: Icon(Icons.emoji_events), text: 'Leaderboard'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScoresScreen(),
            MachinesScreen(),
            LeaderboardScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(12.0),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  onPressed: () => _showLogoutDialog(context),
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
                  onPressed: () => _showSettingsModal(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
