import 'package:flutter/material.dart';
import '../data/scores_repository.dart';

/// Screen displaying the real games history & stats from WorldPinball GraphQL API.
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
      future: repository.getMyScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Erreur API: ${snapshot.error}',
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
              'Aucune partie enregistrée sur l\'API.\nScannez un flipper pour enregistrer votre premier score !',
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
                    _buildStatItem('TOTAL PARTIES', '${games.length}', Colors.white),
                    Container(width: 1, height: 40, color: Colors.grey.shade800),
                    _buildStatItem(
                      'MEILLEUR SCORE',
                      games.first['score'].toString(),
                      Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'HISTORIQUE RÉCENT',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.1),
            ),
            const SizedBox(height: 8),

            // Games List
            ...games.map((game) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                color: const Color(0xFF1E1E1E),
                child: ListTile(
                  leading: const Icon(
                    Icons.sports_esports,
                    color: Color(0xFFE53935),
                  ),
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
