import 'package:flutter_bloc/flutter_bloc.dart';

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
    }
  }

  Future<void> logout() async {
    emit(AuthState(status: AuthStatus.loading, profile: state.profile));
    try {
      await _authRepository.logout();
    } finally {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }
}
