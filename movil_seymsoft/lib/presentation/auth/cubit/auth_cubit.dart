import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
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
=======
import '../../../data/models/auth_models.dart';
import '../../../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  checking,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthProfile? profile;
  final String? errorMessage;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> restoreSession() async {
    emit(const AuthState(status: AuthStatus.checking));
    final profile = await _authRepository.restoreSession();
    emit(
      profile == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, profile: profile),
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberSession,
  }) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final profile = await _authRepository.login(
        email: email.trim(),
        password: password,
        rememberSession: rememberSession,
      );
      emit(AuthState(status: AuthStatus.authenticated, profile: profile));
    } on AuthException catch (error) {
      emit(AuthState(status: AuthStatus.failure, errorMessage: error.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Ocurrió un error inesperado',
        ),
      );
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
    }
  }

  Future<void> logout() async {
<<<<<<< HEAD
    final tokenStorage = TokenStorage();
    await tokenStorage.clear();
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
=======
    emit(AuthState(status: AuthStatus.loading, profile: state.profile));
    try {
      await _authRepository.logout();
    } finally {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
>>>>>>> c59aa504a86e6edee56620158e4457253479e51d
  }
}
