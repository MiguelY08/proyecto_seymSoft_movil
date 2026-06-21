import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/sale_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/sales_repository.dart';

enum SalesStatus { initial, loading, success, failure }

class SalesState {
  const SalesState({
    this.status = SalesStatus.initial,
    this.sales = const [],
    this.details = const {},
    this.loadingDetailIds = const {},
    this.detailErrors = const {},
    this.page = 0,
    this.total = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final SalesStatus status;
  final List<Sale> sales;
  final Map<int, Sale> details;
  final Set<int> loadingDetailIds;
  final Map<int, String> detailErrors;
  final int page;
  final int total;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? errorMessage;

  SalesState copyWith({
    SalesStatus? status,
    List<Sale>? sales,
    Map<int, Sale>? details,
    Set<int>? loadingDetailIds,
    Map<int, String>? detailErrors,
    int? page,
    int? total,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SalesState(
      status: status ?? this.status,
      sales: sales ?? this.sales,
      details: details ?? this.details,
      loadingDetailIds: loadingDetailIds ?? this.loadingDetailIds,
      detailErrors: detailErrors ?? this.detailErrors,
      page: page ?? this.page,
      total: total ?? this.total,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SalesCubit extends Cubit<SalesState> {
  SalesCubit(this._repository) : super(const SalesState());

  final SalesRepository _repository;

  Future<void> loadSales({bool refresh = false}) async {
    if (refresh || state.status == SalesStatus.initial) {
      emit(const SalesState(status: SalesStatus.loading));
    } else if (state.isLoadingMore || !state.hasNextPage) {
      return;
    } else {
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    }

    final nextPage = refresh || state.page == 0 ? 1 : state.page + 1;
    try {
      final result = await _repository.getSales(page: nextPage);
      emit(
        state.copyWith(
          status: SalesStatus.success,
          sales: nextPage == 1
              ? result.sales
              : [...state.sales, ...result.sales],
          page: result.page,
          total: result.total,
          hasNextPage: result.hasNextPage,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: state.sales.isEmpty
              ? SalesStatus.failure
              : SalesStatus.success,
          isLoadingMore: false,
          errorMessage: error.message,
        ),
      );
    }
  }

  Future<void> loadDetail(int saleId) async {
    if (state.details.containsKey(saleId) ||
        state.loadingDetailIds.contains(saleId)) {
      return;
    }

    emit(
      state.copyWith(
        loadingDetailIds: {...state.loadingDetailIds, saleId},
        detailErrors: {...state.detailErrors}..remove(saleId),
      ),
    );

    try {
      final detail = await _repository.getSaleDetail(saleId);
      emit(
        state.copyWith(
          details: {...state.details, saleId: detail},
          loadingDetailIds: {...state.loadingDetailIds}..remove(saleId),
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          loadingDetailIds: {...state.loadingDetailIds}..remove(saleId),
          detailErrors: {...state.detailErrors, saleId: error.message},
        ),
      );
    }
  }
}
