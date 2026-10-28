import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';
import '../../auth/data/auth_repository.dart';

class ScoresRepository {
  final AuthRepository _authRepository = AuthRepository();

  /// Fetches the authenticated player's personal scores from GraphQL API
  Future<List<Map<String, dynamic>>> getMyScores() async {
    const query = '''
      query {
        myScores(order: { achievedAtUtc: DESC }) {
          scoreEntryId
          score
          achievedAtUtc
          machine {
            displayName
          }
        }
      }
    ''';

    final authHeaders = await _authRepository.getAuthHeaders();

    final response = await http.post(
      Uri.parse(ApiConfig.graphqlUrl),
      headers: {
        'Content-Type': 'application/json',
        ...authHeaders,
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body.containsKey('errors')) {
        throw Exception(body['errors'][0]['message']);
      }

      final List<dynamic> scoresJson = body['data']['myScores'] ?? [];

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

  static String _formatScore(dynamic score) {
    if (score == null) return '0';
    final n = int.tryParse(score.toString()) ?? 0;
    // Format avec des espaces pour la lisibilité
    return n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  static String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      final d = DateTime.parse(dateStr.toString()).toLocal();
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr.toString();
    }
  }
}
