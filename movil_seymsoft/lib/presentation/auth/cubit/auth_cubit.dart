import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../core/storage/token_storage.dart';

enum AuthStatus { initial, checking, authenticated, unauthenticated, loading, failure }

class AuthState {
  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({AuthStatus? status, String? errorMessage, bool clearError = false}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState()) {
    TokenStorage.registerOnClear(() {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
    });
  }

  final AuthRepository _repository;

  /// Intenta restaurar una sesión existente leyendo el token en almacenamiento.
  Future<void> restoreSession() async {
    emit(state.copyWith(status: AuthStatus.checking, clearError: true));
    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        emit(state.copyWith(status: AuthStatus.authenticated, clearError: true));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
      }
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Realiza login usando el repositorio y actualiza el estado.
  Future<void> login({required String email, required String password, required bool remember}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await _repository.login(email: email, password: password, rememberSession: remember);
      emit(state.copyWith(status: AuthStatus.authenticated, clearError: true));
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Error inesperado'));
    }
  }

  Future<void> logout() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.clear();
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
  }
}
