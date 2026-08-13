class ApiConfig {
  ApiConfig._();

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const String _productionBaseUrl = 'https://api.seymsoft.dev/api';

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    return _productionBaseUrl;
  }
}
