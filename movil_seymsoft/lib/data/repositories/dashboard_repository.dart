import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/dashboard_models.dart';
import 'auth_repository.dart';

class DashboardRepository {
  const DashboardRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<DashboardIndicators> getDashboardIndicators() async {
    try {
      final response = await _apiClient.dio.get('/indicators/dashboard');
      return DashboardIndicators.fromJson(_extractData(response));
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    }
  }

  Map<String, dynamic> _extractData(Response<dynamic> response) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) return data;
      return body;
    }
    return const {};
  }

  String _messageFromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'No fue posible conectar con el servidor';
    }
    return 'No fue posible cargar el dashboard';
  }
}
