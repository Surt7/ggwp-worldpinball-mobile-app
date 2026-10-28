import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';
import '../../auth/data/auth_repository.dart';

class ScoresRepository {
  final AuthRepository _authRepository = AuthRepository();

  /// Fetches aggregate stats directly computed by PostgreSQL (count and best score)
  Future<Map<String, dynamic>> getMyScoreStats({String? modeCode}) async {
    final modeArg = (modeCode != null && modeCode != 'all') ? 'modeCode: "$modeCode"' : '';
    final query = '''
      query {
        myScoreStats($modeArg) {
          totalGames
          bestScore
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

      final stats = body['data']?['myScoreStats'] ?? {};
      return {
        'totalGames': stats['totalGames'] ?? 0,
        'bestScore': _formatScore(stats['bestScore']),
      };
    } else {
      throw Exception('Erreur serveur stats: ${response.statusCode} - ${response.body}');
    }
  }

  /// Fetches paginated personal scores (20 by 20) with optional mode filtering
  Future<List<Map<String, dynamic>>> getMyScores({
    int skip = 0,
    int take = 20,
    String? modeCode,
  }) async {
    String whereFilter = '';
    if (modeCode != null && modeCode != 'all') {
      whereFilter = ', where: { mode: { code: { eq: "$modeCode" } } }';
    }

    final query = '''
      query {
        myScores(skip: $skip, take: $take, order: { achievedAtUtc: DESC }$whereFilter) {
          scoreEntryId
          score
          achievedAtUtc
          machine {
            displayName
          }
          mode {
            code
            name
          }
          ipLicense {
            name
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

      final List<dynamic> scoresJson = body['data']?['myScores'] ?? [];

      return scoresJson.map((json) {
        return {
          'machine': json['machine']?['displayName']?.toString() ?? 'Flipper WorldPinball',
          'modeCode': json['mode']?['code']?.toString(),
          'modeName': json['mode']?['name']?.toString() ?? 'Standard',
          'licenseName': json['ipLicense']?['name']?.toString() ?? 'Resident Evil',
          'score': _formatScore(json['score']),
          'date': _formatDate(json['achievedAtUtc']),
        };
      }).toList();
    } else {
      throw Exception('Erreur serveur scores: ${response.statusCode} - ${response.body}');
    }
  }

  static String _formatScore(dynamic score) {
    if (score == null) return '0';
    final n = int.tryParse(score.toString()) ?? 0;
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
