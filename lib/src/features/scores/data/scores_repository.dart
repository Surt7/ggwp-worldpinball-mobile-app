import 'dart:convert';
import 'package:http/http.dart' as http;

/// Production Repository fetching personal user scores from C# Hot Chocolate GraphQL API.
class ScoresRepository {
  final String _graphqlUrl = 'https://api.worldpinball.local/graphql';

  Future<List<Map<String, dynamic>>> getMyScores(String userId) async {
    // GraphQL Query with HotChocolate filtering
    const query = '''
      query GetMyScores(\$userId: String!) {
        scores(where: { userProfileId: { eq: \$userId } }, order: { scoreValue: DESC }) {
          id
          scoreValue
          createdAt
          machine {
            displayName
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(_graphqlUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': query,
        'variables': {'userId': userId},
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
          'machine': json['machine']?['displayName'] ?? 'Unknown Machine',
          'score': json['scoreValue']?.toString() ?? '0',
          'date': json['createdAt']?.toString() ?? 'Recent',
        };
      }).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}