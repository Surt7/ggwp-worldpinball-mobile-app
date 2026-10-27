import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config/api_config.dart';
import '../domain/machine.dart';

class MachineRepository {
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
      final List<dynamic> machinesJson = body['data']['machines'] ?? [];
      return machinesJson.map((json) => Machine.fromJson(json)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode} - ${response.body}');
    }
  }
}
