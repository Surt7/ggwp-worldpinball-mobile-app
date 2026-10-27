import 'dart:convert';
import 'package:http/http.dart' as http;

/// Production Repository handling User Profile GraphQL queries and Machine registration mutations.
class ProfileRepository {
  final String _graphqlUrl = 'https://api.worldpinball.local/graphql';

  /// Fetches the user profile from GraphQL
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    const query = '''
      query GetProfile(\$userId: String!) {
        profiles(where: { userId: { eq: \$userId } }) {
          userId
          displayName
          countryCode
          isProfilePublic
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
      final List<dynamic> profiles = body['data']['profiles'] ?? [];
      if (profiles.isNotEmpty) {
        return profiles.first as Map<String, dynamic>;
      }
      throw Exception('Profile not found');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Sends a GraphQL Mutation to register a new pinball machine
  Future<bool> registerMachine({
    required String displayName,
    required String manufacturer,
    required String serialNumber,
  }) async {
    const mutation = '''
      mutation RegisterMachine(\$displayName: String!, \$manufacturer: String!, \$serialNumber: String!) {
        addMachine(input: {
          displayName: \$displayName,
          manufacturer: \$manufacturer,
          serialNumber: \$serialNumber
        }) {
          machineId
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(_graphqlUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': mutation,
        'variables': {
          'displayName': displayName,
          'manufacturer': manufacturer,
          'serialNumber': serialNumber,
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return !body.containsKey('errors');
    }
    return false;
  }
}