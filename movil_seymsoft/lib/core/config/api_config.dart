import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const _localNetworkBaseUrl = 'http://192.168.1.33:3000/api';

  // Proxy usado solo en desarrollo web para evitar problemas de CORS
  // Levanta un proxy (ej. cors-anywhere) en http://localhost:8080
  // y reenvía peticiones a http://localhost:3000
  static const _webDevProxy = 'http://localhost:8080/http://localhost:3000/api';

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

<<<<<<< HEAD
    if (kIsWeb) return _webDevProxy;

    return _localNetworkBaseUrl;
=======
    return kIsWeb ? 'http://127.0.0.1:3000/api' : 'http://10.0.2.2:3000/api';
>>>>>>> e0711a3a781853125ee87da60ddf315603be744b
  }
}
