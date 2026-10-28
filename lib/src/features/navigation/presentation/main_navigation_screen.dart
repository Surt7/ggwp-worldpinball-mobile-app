import 'package:flutter/material.dart';
import '../../games/data/game_session_repository.dart';
import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../machines/presentation/machines_screen.dart';
import '../../profile/presentaiton/profile_screen.dart';
import '../../scores/presentation/scores_screen.dart';
import 'widgets/main_bottom_bar.dart';

// Main navigation shell hosting the 4 core tabs and persistent bottom arcade bar
class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final _sessionRepository = GameSessionRepository();
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
  }

  Future<void> _checkActiveSession() async {
    try {
      final session = await _sessionRepository.getMyActiveSession();
      if (mounted) {
        setState(() {
          _hasActiveSession = session != null;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'WORLD PINBALL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: const Color(0xFFE53935),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                icon: Badge(
                  isLabelVisible: _hasActiveSession,
                  backgroundColor: const Color(0xFF00E676),
                  smallSize: 8,
                  child: const Icon(Icons.leaderboard),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Mes Scores'),
                    if (_hasActiveSession) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(icon: Icon(Icons.videogame_asset), text: 'Machines'),
              const Tab(icon: Icon(Icons.emoji_events), text: 'Leaderboard'),
              const Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ScoresScreen(),
            const MachinesScreen(),
            const LeaderboardScreen(),
            ProfileScreen(onLogout: widget.onLogout),
          ],
        ),
        bottomNavigationBar: MainBottomBar(onLogout: widget.onLogout),
      ),
    );
  }
}
