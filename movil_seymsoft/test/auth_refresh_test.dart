import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movil_seymsoft/data/repositories/auth_repository.dart';
import 'package:movil_seymsoft/core/storage/token_storage.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'refresh_token': 'old-refresh'});
  });

  test(
    'refreshSession guarda nuevos tokens cuando el endpoint responde correctamente',
    () async {
      final mockDio = MockDio();
      final tokenStorage = TokenStorage();

      final response = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: {
          'data': {'accessToken': 'new-access', 'refreshToken': 'new-refresh'},
        },
        statusCode: 200,
      );

      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      final result = await AuthRepository.refreshSession(
        tokenStorage,
        client: mockDio,
      );
      expect(result, isTrue);

      final storedRefresh = await tokenStorage.getRefreshToken();
      final storedAccess = await tokenStorage.getAccessToken();
      expect(storedRefresh, equals('new-refresh'));
      expect(storedAccess, equals('new-access'));
    },
  );

  test(
    'refreshSession devuelve false si no hay refresh token en storage',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      final mockDio = MockDio();
      final tokenStorage = TokenStorage();

      final result = await AuthRepository.refreshSession(
        tokenStorage,
        client: mockDio,
      );
      expect(result, isFalse);
    },
  );
}
