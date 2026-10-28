/// Real API Configuration targeting the WorldPinball BFF Gateway.
class ApiConfig {
  static const String graphqlUrl = String.fromEnvironment(
    'GRAPHQL_URL',
    defaultValue: 'https://bff.worldpinball.local/graphql',
  );

  static const String lobbyHubUrl = String.fromEnvironment(
    'LOBBY_HUB_URL',
    defaultValue: 'https://bff.worldpinball.local/hubs/lobby',
  );
}
