import 'package:flutter/material.dart';
import '../data/scores_repository.dart';

/// Screen displaying the logged-in player's personal games history & stats from GraphQL API.
class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final repository = ScoresRepository();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repository.getMyScores('user_123'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'GraphQL Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final games = snapshot.data ?? [];

        if (games.isEmpty) {
          return const Center(
            child: Text(
              'No games recorded yet.\nScan a pinball machine to log your first score!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Stats Summary Banner
            Card(
              color: const Color(0xFF1E1E1E),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('TOTAL GAMES', '${games.length}', Colors.white),
                    Container(width: 1, height: 40, color: Colors.grey.shade800),
                    _buildStatItem('BEST SCORE', games.first['score'].toString(), Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'RECENT GAMES HISTORY',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.1),
            ),
            const SizedBox(height: 8),

            // Real GraphQL Games List
            ...games.map((game) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                color: const Color(0xFF1E1E1E),
                child: ListTile(
                  leading: const Icon(Icons.sports_esports, color: Color(0xFFE53935)),
                  title: Text(
                    game['machine'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    game['date'].toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Text(
                    game['score'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}