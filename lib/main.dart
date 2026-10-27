import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_pinball_gg_wp/src/features/machines/presentation/machines_screen.dart';
import 'package:world_pinball_gg_wp/src/features/profile/presentaiton/profile_screen.dart';
import 'package:world_pinball_gg_wp/src/shared/theme/app_theme.dart';
import 'src/features/machines/data/machine_repository.dart';
import 'src/features/machines/bloc/machines_bloc.dart';
import 'src/features/machines/bloc/machines_event.dart';
import 'src/features/leaderboard/presentation/LeaderboardScreen.dart';
import 'src/features/qr_code/presentation/qr_pass_screen.dart';
import 'src/features/scores/presentation/scores_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Pinball',
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
                  onPressed: () {},
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
