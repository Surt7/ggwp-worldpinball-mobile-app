import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';
import '../../auth/data/auth_repository.dart';

// Repository responsible for joining and interacting with live pinball game sessions
class GameSessionRepository {
  final AuthRepository _authRepository = AuthRepository();

  // Sends the joinGameSession GraphQL mutation to the backend
  Future<Map<String, dynamic>> joinGameSession(String code) async {
    // 1. Define the GraphQL mutation string targeting joinGameSession
    const mutation = '''
      mutation JoinGameSession(\$code: String!) {
        joinGameSession(code: \$code) {
          success
          message
          slotNumber
          machineName
        }
      }
    ''';

    // 2. Fetch authenticated JWT headers from Keycloak
    final authHeaders = await _authRepository.getAuthHeaders();

    // 3. Send HTTP POST request to GraphQL endpoint
    final response = await http.post(
      Uri.parse(ApiConfig.graphqlUrl),
      headers: {'Content-Type': 'application/json', ...authHeaders},
      body: jsonEncode({
        'query': mutation,
        'variables': {'code': code.trim()},
      }),
    );

    // 4. Process HTTP response and handle GraphQL payload
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      // Check for top-level GraphQL errors (syntax, token expiration, schema validation)
      if (body.containsKey('errors')) {
        throw Exception(body['errors'][0]['message']);
      }

      // Extract and return our JoinGameSessionPayload map
      return body['data']['joinGameSession'] as Map<String, dynamic>;
    } else {
      throw Exception(
        'Server error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Fetches current active session for the authenticated user, or null if none
  Future<Map<String, dynamic>?> getMyActiveSession() async {
    // 1. Define the GraphQL query requesting active session fields
    const query = '''
      query {
        myActiveSession {
          sessionId
          machineName
          modeName
          slotNumber
          state
          startedAtUtc
        }
      }
    ''';

    // 2. Fetch authenticated JWT headers from Keycloak
    final authHeaders = await _authRepository.getAuthHeaders();

    // 3. Send HTTP POST request to GraphQL endpoint
    final response = await http.post(
      Uri.parse(ApiConfig.graphqlUrl),
      headers: {'Content-Type': 'application/json', ...authHeaders},
      body: jsonEncode({'query': query}),
    );

    // 4. Process HTTP response and return active session map (or null if none)
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body.containsKey('errors')) {
        throw Exception(body['errors'][0]['message']);
      }
      // If no session is active, GraphQL returns null: body['data']['myActiveSession'] is null
      return body['data']['myActiveSession'] as Map<String, dynamic>?;
    } else {
      throw Exception(
        'Server error: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
