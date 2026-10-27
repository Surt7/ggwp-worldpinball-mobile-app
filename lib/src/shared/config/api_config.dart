/// Real API Configuration targeting the WorldPinball BFF Gateway.
class ApiConfig {
  static const String graphqlUrl = String.fromEnvironment(
    'GRAPHQL_URL',
    defaultValue: 'https://bff.worldpinball.local/graphql',
  );
}
