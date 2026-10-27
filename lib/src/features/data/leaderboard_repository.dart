import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaderboardRepository {
  final String _graphqlUrl = 'http://api.worldpinball.local/graphql';

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    const query = '''
      query {
        scores(order: { scoreValue: DESC }) {
          id
          scoreValue
          userProfile {
            displayName
          }
          machine {
            displayName
          }
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse(_graphqlUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> scoresJson = body['data']['scores'];

        return scoresJson.asMap().entries.map((entry) {
          final index = entry.key;
          final json = entry.value;
          return {
            'rank': index + 1,
            'player': json['userProfile']?['displayName'] ?? 'Unknown Player',
            'machine': json['machine']?['displayName'] ?? 'Unknown Machine',
            'score': json['scoreValue']?.toString() ?? '0',
          };
        }).toList();
      } else {
        return _getMockScores();
      }
    } catch (_) {
      return _getMockScores();
    }
  }

  List<Map<String, dynamic>> _getMockScores() {
    return [
      {'rank': 1, 'player': 'Tommy_Wizard', 'machine': 'Resident Evil', 'score': '2,450,890,100'},
      {'rank': 2, 'player': 'PinballKing', 'machine': 'Godzilla Premium', 'score': '1,980,450,000'},
      {'rank': 3, 'player': 'SilverBall_88', 'machine': 'Venom', 'score': '1,420,100,500'},
      {'rank': 4, 'player': 'RetroGamer', 'machine': 'Resident Evil', 'score': '980,300,200'},
    ];
  }
}
