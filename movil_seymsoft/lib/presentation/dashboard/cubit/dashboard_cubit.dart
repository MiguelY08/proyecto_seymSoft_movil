import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/dashboard_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/dashboard_repository.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.indicators,
    this.errorMessage,
  });

  final DashboardStatus status;
  final DashboardIndicators? indicators;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardIndicators? indicators,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      indicators: indicators ?? this.indicators,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  Future<void> loadDashboard({bool refresh = false}) async {
    if (!refresh && state.status == DashboardStatus.loading) return;

    emit(
      state.copyWith(
        status: state.indicators == null
            ? DashboardStatus.loading
            : DashboardStatus.success,
        clearError: true,
      ),
    );

    try {
      final indicators = await _repository.getDashboardIndicators();
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          indicators: indicators,
          clearError: true,
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: state.indicators == null
              ? DashboardStatus.failure
              : DashboardStatus.success,
          errorMessage: error.message,
        ),
      );
    }
  }
}
