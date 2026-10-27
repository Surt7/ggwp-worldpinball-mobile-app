import 'package:flutter/material.dart';

/// Screen displaying the logged-in player's personal games history & stats.
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
    final myRecentGames = [
      {
        'machine': 'Resident Evil: Death Island',
        'score': '2,450,890,100',
        'date': 'Today, 14:32',
        'isPersonalBest': true,
      },
      {
        'machine': 'Godzilla Premium',
        'score': '1,120,450,000',
        'date': 'Yesterday, 21:15',
        'isPersonalBest': false,
      },
      {
        'machine': 'Resident Evil: Death Island',
        'score': '890,300,000',
        'date': '12 Oct, 18:04',
        'isPersonalBest': false,
      },
      {
        'machine': 'Venom',
        'score': '1,420,100,500',
        'date': '10 Oct, 19:45',
        'isPersonalBest': true,
      },
    ];

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
                _buildStatItem('TOTAL GAMES', '42', Colors.white),
                Container(width: 1, height: 40, color: Colors.grey.shade800),
                _buildStatItem('BEST SCORE', '2.45B', Theme.of(context).colorScheme.primary),
                Container(width: 1, height: 40, color: Colors.grey.shade800),
                _buildStatItem('AVG SCORE', '1.10B', Colors.grey),
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

        // List of Recent Games
        ...myRecentGames.map((game) {
          final isPB = game['isPersonalBest'] as bool;
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            color: const Color(0xFF1E1E1E),
            child: ListTile(
              leading: Icon(
                Icons.sports_esports,
                color: isPB ? Colors.amber : Colors.grey,
              ),
              title: Text(
                game['machine'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                game['date'].toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    game['score'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isPB ? Colors.amber : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (isPB)
                    const Text(
                      '★ PERSONAL BEST',
                      style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}