import 'package:flutter/material.dart';



class LeaderboardCard extends StatelessWidget {
  // 1. Declare the data field for a single score entry
  final Map<String, dynamic> entry;

  const LeaderboardCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    // Determine badge color based on podium rank
    final rank = entry['rank'] as int;
    Color rankColor = Colors.grey;
    if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
    if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
    if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        // Left side: Rank badge (#1, #2, #3)
        leading: CircleAvatar(
          backgroundColor: rankColor.withValues(alpha: 0.2),
          child: Text(
            '#$rank',
            style: TextStyle(
              color: rankColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Center: Player name & Machine
        title: Text(
          entry['player'].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(entry['machine'].toString()),
        // Right side: High Score value
        trailing: Text(
          entry['score'].toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
