import 'package:flutter/material.dart';
import 'leaderboard_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Simulated GraphQL score entries for UI development
    final mockScores = [
      {'rank': 1, 'player': 'Tommy_Wizard', 'machine': 'Resident Evil', 'score': '2,450,890,100'},
      {'rank': 2, 'player': 'PinballKing', 'machine': 'Godzilla Premium', 'score': '1,980,450,000'},
      {'rank': 3, 'player': 'SilverBall_88', 'machine': 'Venom', 'score': '1,420,100,500'},
      {'rank': 4, 'player': 'RetroGamer', 'machine': 'Resident Evil', 'score': '980,300,200'},
    ];




    return ListView.builder(
      itemCount: mockScores.length,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context,index){
        final entry = mockScores[index];

        return LeaderboardCard(entry: entry);
      },
    );


  }


}

