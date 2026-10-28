import 'package:flutter/material.dart';
import '../../../shared/widgets/game_mode_filter_bar.dart';
import '../data/scores_repository.dart';

/// Screen displaying the real personal games history & stats with Game Mode & License filtering.
class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  final _repository = ScoresRepository();
  late Future<List<Map<String, dynamic>>> _scoresFuture;

  String _selectedModeId = 'all';
  String _selectedLicense = 'Resident Evil: Death Island';

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() {
    _scoresFuture = _repository.getMyScores();
  }

  static Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _filterGames(List<Map<String, dynamic>> allGames) {
    if (_selectedModeId == 'all') {
      return allGames;
    }

    final modeItem = kGameModes.firstWhere(
      (m) => m.id == _selectedModeId,
      orElse: () => const GameModeItem(id: 'all', label: 'Tous', icon: Icons.sports_esports),
    );

    return allGames.where((entry) {
      final code = entry['modeCode']?.toString().toLowerCase() ?? '';
      final name = entry['modeName']?.toString().toLowerCase() ?? '';
      final target = modeItem.id.toLowerCase();
      final labelTarget = modeItem.label.toLowerCase();

      return code.contains(target) || name.contains(labelTarget) || code.contains(labelTarget);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _scoresFuture,
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
                    'Erreur API : ${snapshot.error}',
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

        final allGames = snapshot.data ?? [];
        final games = _filterGames(allGames);

        final bestScore = games.isNotEmpty ? games.first['score'].toString() : '-';

        return RefreshIndicator(
          color: const Color(0xFFE53935),
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: () async {
            setState(() => _loadScores());
            await _scoresFuture;
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. License & Game Mode Filter Bar
              GameModeFilterBar(
                selectedModeId: _selectedModeId,
                onModeSelected: (modeId) {
                  setState(() => _selectedModeId = modeId);
                },
                selectedLicense: _selectedLicense,
              ),
              const SizedBox(height: 16),

              // 2. Stats Summary Banner
              Card(
                color: const Color(0xFF1E1E1E),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('TOTAL PARTIES', '${games.length}', Colors.white),
                      Container(width: 1, height: 40, color: Colors.grey.shade800),
                      _buildStatItem(
                        'MEILLEUR SCORE',
                        bestScore,
                        const Color(0xFFE53935),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HISTORIQUE RÉCENT',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.1,
                    ),
                  ),
                  if (_selectedModeId != 'all')
                    Text(
                      'Mode : ${_selectedModeName()}',
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 4. Games List or Empty State
              if (games.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_esports_outlined,
                          size: 48,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aucune partie enregistrée en mode ${_selectedModeName()}.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...games.map((game) {
                  final modeName = game['modeName']?.toString();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade900),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sports_esports,
                          color: Color(0xFFE53935),
                          size: 22,
                        ),
                      ),
                      title: Text(
                        game['machine'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            game['date'].toString(),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          if (modeName != null && modeName.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                modeName,
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ),
                        ],
                      ),
                      trailing: Text(
                        game['score'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFFE53935),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }),
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
