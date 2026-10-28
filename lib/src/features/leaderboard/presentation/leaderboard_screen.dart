import 'package:flutter/material.dart';
import '../../../shared/widgets/game_mode_filter_bar.dart';
import '../data/leaderboard_repository.dart';
import 'leaderboard_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _repository = LeaderboardRepository();
  late Future<List<Map<String, dynamic>>> _leaderboardFuture;

  String _selectedModeId = 'all';
  String _selectedLicense = 'Resident Evil: Death Island';

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() {
    _leaderboardFuture = _repository.getLeaderboard();
  }

  List<Map<String, dynamic>> _filterScores(List<Map<String, dynamic>> allScores) {
    if (_selectedModeId == 'all') {
      return allScores;
    }

    final modeItem = kGameModes.firstWhere(
      (m) => m.id == _selectedModeId,
      orElse: () => const GameModeItem(id: 'all', label: 'Tous', icon: Icons.sports_esports),
    );

    // Filter by matching mode code or mode name
    final filtered = allScores.where((entry) {
      final code = entry['modeCode']?.toString().toLowerCase() ?? '';
      final name = entry['modeName']?.toString().toLowerCase() ?? '';
      final target = modeItem.id.toLowerCase();
      final labelTarget = modeItem.label.toLowerCase();

      return code.contains(target) || name.contains(labelTarget) || code.contains(labelTarget);
    }).toList();

    // Re-rank for the filtered view
    return filtered.asMap().entries.map((e) {
      final item = Map<String, dynamic>.from(e.value);
      item['rank'] = e.key + 1;
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _leaderboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Erreur : ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _loadScores()),
                    child: const Text('RÉESSAYER'),
                  ),
                ],
              ),
            ),
          );
        }

        final rawScores = snapshot.data ?? [];
        final filteredScores = _filterScores(rawScores);

        return RefreshIndicator(
          color: const Color(0xFFE53935),
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: () async {
            setState(() => _loadScores());
            await _leaderboardFuture;
          },
          child: CustomScrollView(
            slivers: [
              // 1. License & Game Mode Filter Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: GameModeFilterBar(
                    selectedModeId: _selectedModeId,
                    onModeSelected: (modeId) {
                      setState(() => _selectedModeId = modeId);
                    },
                    selectedLicense: _selectedLicense,
                  ),
                ),
              ),

              // 2. Scores Count or Empty state
              if (filteredScores.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_esports_outlined,
                            size: 64,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun score enregistré pour le mode ${_selectedModeName()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Soyez le premier à poser votre record sur Resident Evil !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return LeaderboardCard(entry: filteredScores[index]);
                      },
                      childCount: filteredScores.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _selectedModeName() {
    final mode = kGameModes.firstWhere(
      (m) => m.id == _selectedModeId,
      orElse: () => const GameModeItem(id: 'all', label: 'Tous', icon: Icons.sports_esports),
    );
    return mode.label;
  }
}
