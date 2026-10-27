import 'dart:convert';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String? sub;
  final String? username;
  final String? name;
  final String? email;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.sub,
    this.username,
    this.name,
    this.email,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String;
    final refreshToken = json['refresh_token'] as String? ?? '';
    final expiresIn = json['expires_in'] as int? ?? 300;

    String? sub;
    String? username;
    String? name;
    String? email;

    try {
      final parts = accessToken.split('.');
      if (parts.length == 3) {
        final normalized = base64Url.normalize(parts[1]);
        final payloadString = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> payload = jsonDecode(payloadString);
        sub = payload['sub'] as String?;
        username = payload['preferred_username'] as String?;
        name = payload['name'] as String?;
        email = payload['email'] as String?;
      }
    } catch (_) {
      // Ignore token parse failure, tokens are still valid
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      sub: sub,
      username: username,
      name: name,
      email: email,
    );
  }
}
