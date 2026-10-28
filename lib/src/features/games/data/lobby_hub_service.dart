import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../shared/config/api_config.dart';
import '../../auth/data/auth_repository.dart';

// Service managing real-time SignalR connection to the WorldPinball LobbyHub
class LobbyHubService {
  final AuthRepository _authRepository = AuthRepository();
  HubConnection? _hubConnection;
  String? _currentSessionId;

  // Connects to LobbyHub, joins session group, and listens for live lobby updates
  Future<void> connect({
    required String sessionId,
    required void Function(Map<String, dynamic> update) onLobbyUpdated,
    VoidCallback? onConnectionClosed,
  }) async {
    // If already connected to the same session, do not recreate
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected &&
        _currentSessionId == sessionId) {
      return;
    }

    // Stop previous connection if active
    await disconnect();

    _currentSessionId = sessionId;

    try {
      final httpOptions = HttpConnectionOptions(
        accessTokenFactory: () async {
          final token = await _authRepository.getAccessToken();
          return token ?? '';
        },
      );

      _hubConnection = HubConnectionBuilder()
          .withUrl(ApiConfig.lobbyHubUrl, options: httpOptions)
          .withAutomaticReconnect()
          .build();

      // Listen for incoming live state updates from the server
      _hubConnection!.on('LobbyStateUpdated', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final payload = arguments.first;
          if (payload is Map<String, dynamic>) {
            debugPrint('[LobbyHubService] Live update received: $payload');
            onLobbyUpdated(payload);
          } else if (payload is Map) {
            final mapped = Map<String, dynamic>.from(payload);
            debugPrint('[LobbyHubService] Live update received: $mapped');
            onLobbyUpdated(mapped);
          }
        }
      });

      _hubConnection!.onclose(({error}) {
        debugPrint('[LobbyHubService] Connection closed: $error');
        if (onConnectionClosed != null) {
          onConnectionClosed();
        }
      });

      // Start the WebSocket connection
      await _hubConnection!.start();
      debugPrint('[LobbyHubService] Connected to ${ApiConfig.lobbyHubUrl}');

      // Join the session lobby group on the server
      await _hubConnection!.invoke('JoinLobby', args: <Object>[sessionId]);
      debugPrint(
        '[LobbyHubService] Joined lobby group for session: $sessionId',
      );
    } catch (e) {
      debugPrint('[LobbyHubService] Connection error: $e');
    }
  }

  // Gracefully leaves session room and terminates the connection
  Future<void> disconnect() async {
    if (_hubConnection != null) {
      try {
        if (_currentSessionId != null &&
            _hubConnection!.state == HubConnectionState.Connected) {
          await _hubConnection!.invoke('LeaveLobby', args: <Object>[_currentSessionId!]);
        }
        await _hubConnection!.stop();
      } catch (e) {
        debugPrint('[LobbyHubService] Error during disconnect: $e');
      } finally {
        _hubConnection = null;
        _currentSessionId = null;
      }
    }
  }

  // Checks whether the connection is currently alive
  bool get isConnected =>
      _hubConnection != null &&
      _hubConnection!.state == HubConnectionState.Connected;
}
