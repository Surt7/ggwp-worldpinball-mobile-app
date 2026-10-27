import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../domain/auth_tokens.dart';

class AuthRepository {
  static const String _tokenEndpoint =
      'https://auth.worldpinball.local/realms/worldpinball/protocol/openid-connect/token';
  static const String _clientId = 'worldpinball-mobile';

  static const String _accessTokenKey = 'wp_access_token';
  static const String _refreshTokenKey = 'wp_refresh_token';
  static const String _subKey = 'wp_sub';
  static const String _usernameKey = 'wp_username';

  final FlutterSecureStorage _storage;

  AuthRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<AuthTokens> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(_tokenEndpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': _clientId,
        'grant_type': 'password',
        'username': username.trim(),
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tokens = AuthTokens.fromJson(json);

      await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
      await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
      if (tokens.sub != null) {
        await _storage.write(key: _subKey, value: tokens.sub);
      }
      if (tokens.username != null) {
        await _storage.write(key: _usernameKey, value: tokens.username);
      }

      return tokens;
    } else {
      String errorMessage = 'Échec de connexion (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('error_description')) {
          errorMessage = body['error_description'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _subKey);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _subKey);
    await _storage.delete(key: _usernameKey);
  }
}
