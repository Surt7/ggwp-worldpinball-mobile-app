import 'package:flutter/material.dart';
import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../machines/presentation/machines_screen.dart';
import '../../profile/presentaiton/profile_screen.dart';
import '../../scores/presentation/scores_screen.dart';
import 'widgets/main_bottom_bar.dart';

/// Main navigation shell hosting the 4 core tabs and persistent bottom arcade bar.
class MainNavigationScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

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
        body: TabBarView(
          children: [
            const ScoresScreen(),
            const MachinesScreen(),
            const LeaderboardScreen(),
            ProfileScreen(onLogout: onLogout),
          ],
        ),
        bottomNavigationBar: MainBottomBar(onLogout: onLogout),
      ),
    );
  }
}
