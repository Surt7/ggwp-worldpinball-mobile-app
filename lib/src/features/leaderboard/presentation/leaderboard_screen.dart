import 'package:flutter/material.dart';
import 'leaderboard_card.dart';
import '../../data/leaderboard_repository.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = LeaderboardRepository();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repository.getLeaderboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final scores = snapshot.data ?? [];

        if (scores.isEmpty) {
          return const Center(child: Text('No scores found.'));
        }

        return ListView.builder(
          itemCount: scores.length,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemBuilder: (context, index) {
            return LeaderboardCard(entry: scores[index]);
          },
        );
      },
    );


  }


}

