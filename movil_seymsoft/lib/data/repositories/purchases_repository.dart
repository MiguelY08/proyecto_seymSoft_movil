import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/purchase_models.dart';
import 'auth_repository.dart';

class PurchasesRepository {
  const PurchasesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<PurchasesPageResult> getPurchases({
    required int page,
    int limit = 13,
  }) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/supplier-purchases',
        queryParameters: {'page': page, 'limit': limit},
      );
      final body = response.data;
      final data = body?['data'] as List<dynamic>? ?? const [];
      final pagination =
          body?['pagination'] as Map<String, dynamic>? ?? const {};

      return PurchasesPageResult(
        purchases: data
            .map((item) => Purchase.fromJson(item as Map<String, dynamic>))
            .toList(growable: false),
        page: (pagination['page'] as num?)?.toInt() ?? page,
        total: (pagination['total'] as num?)?.toInt() ?? data.length,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      );
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    }
  }

  Future<Purchase> getPurchaseDetail(int purchaseId) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/supplier-purchases/$purchaseId',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const AuthException('No fue posible obtener la compra');
      }
      return Purchase.fromJson(data);
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    }
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
    return 'No fue posible cargar las compras';
  }
}
