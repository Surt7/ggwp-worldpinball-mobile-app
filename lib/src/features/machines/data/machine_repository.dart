import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/machine.dart';

class MachineRepository {
  final AuthRepository _authRepository = AuthRepository();

  /// Fetches the authenticated user's machines (Option A: User -> Device -> Machine)
  Future<List<Machine>> getMachines() async {
    const query = '''
      query {
        machines {
          machineId
          displayName
          manufacturer
          status
          worldPinballSerialNumber
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
      final List<dynamic> machinesJson = body['data']['machines'] ?? [];
      return machinesJson.map((json) => Machine.fromJson(json)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode} - ${response.body}');
    }
  }
}
