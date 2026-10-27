import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/machine.dart';

class MachineRepository {
  final String _graphqlUrl = 'https://api.worldpinball.local/graphql';

  Future<List<Machine>> getMachines() async {
    const query = '''
      query {
        machines {
          machineId
          displayName
          manufacturer
          status
          serialNumber
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse(_graphqlUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> machinesJson = body['data']['machines'];
        return machinesJson.map((json) => Machine.fromJson(json)).toList();
      } else {
        return _getMockMachines();
      }
    } catch (_) {
      return _getMockMachines();
    }
  }

  List<Machine> _getMockMachines() {
    return [
      Machine(
        machineId: '1',
        ipId: 're-death-island',
        displayName: 'Resident Evil: Death Island',
        serialNumber: 'SN-RE-001',
        manufacturer: 'WorldPinball',
        status: 'Online',
        registeredAt: DateTime.now(),
      ),
      Machine(
        machineId: '2',
        ipId: 'godzilla',
        displayName: 'Godzilla Premium',
        serialNumber: 'SN-GZ-042',
        manufacturer: 'Stern Pinball',
        status: 'Offline',
        registeredAt: DateTime.now(),
      ),
    ];
  }
}
