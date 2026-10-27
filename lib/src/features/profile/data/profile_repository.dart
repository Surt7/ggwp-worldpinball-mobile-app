import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';

class ProfileRepository {
  /// Fetches real user profiles from HotChocolate GraphQL API via BFF Gateway
  Future<Map<String, dynamic>?> getUserProfile() async {
    const query = '''
      query {
        profiles {
          userId
          displayName
          countryCode
          isProfilePublic
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
      final List<dynamic> profiles = body['data']?['profiles'] ?? [];
      if (profiles.isNotEmpty) {
        return profiles.first as Map<String, dynamic>;
      }
      return null;
    } else {
      throw Exception('Erreur serveur: ${response.statusCode} - ${response.body}');
    }
  }

  /// Registers a machine on the backend through the BFF Gateway
  Future<bool> registerMachine({
    required String displayName,
    required String manufacturer,
    required String serialNumber,
  }) async {
    final url = Uri.parse('https://bff.worldpinball.local/api/v1/machines/enroll');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceSerialNumber': serialNumber,
        'machineName': displayName,
        'manufacturer': manufacturer,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
