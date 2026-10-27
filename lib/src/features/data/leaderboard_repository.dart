import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/config/api_config.dart';

class LeaderboardRepository {
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    const query = '''
      query {
        scores(order: { score: DESC }) {
          scoreEntryId
          score
          userId
          machine {
            displayName
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(ApiConfig.graphqlUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body.containsKey('errors')) {
        throw Exception(body['errors'][0]['message']);
      }
      final List<dynamic> scoresJson = body['data']['scores'] ?? [];

      return scoresJson.take(50).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final json = entry.value;
        return {
          'rank': index + 1,
          'player': json['userId']?.toString() ?? 'Joueur Anonyme',
          'machine': json['machine']?['displayName']?.toString() ?? 'Flipper WorldPinball',
          'score': _formatScore(json['score']),
        };
      }).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode} - ${response.body}');
    }
  }

  static String _formatScore(dynamic val) {
    if (val == null) return '0';
    if (val is num) {
      return val.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return val.toString();
  }
}
