import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';

class ScoresRepository {
  Future<List<Map<String, dynamic>>> getMyScores({String? userId}) async {
    final String query = (userId != null && userId.isNotEmpty)
        ? '''
      query GetMyScores(\$userId: String!) {
        scores(where: { userId: { eq: \$userId } }, order: { achievedAtUtc: DESC }) {
          scoreEntryId
          score
          achievedAtUtc
          machine {
            displayName
          }
        }
      }
    '''
        : '''
      query {
        scores(order: { achievedAtUtc: DESC }) {
          scoreEntryId
          score
          achievedAtUtc
          machine {
            displayName
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(ApiConfig.graphqlUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': query,
        if (userId != null && userId.isNotEmpty) 'variables': {'userId': userId},
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        throw Exception(body['errors'][0]['message']);
      }

      final List<dynamic> scoresJson = body['data']['scores'] ?? [];

      return scoresJson.map((json) {
        return {
          'machine': json['machine']?['displayName']?.toString() ?? 'Flipper WorldPinball',
          'score': _formatScore(json['score']),
          'date': _formatDate(json['achievedAtUtc']),
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

  static String _formatDate(dynamic val) {
    if (val == null) return 'Date inconnue';
    try {
      final dt = DateTime.parse(val.toString()).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return val.toString();
    }
  }
}
