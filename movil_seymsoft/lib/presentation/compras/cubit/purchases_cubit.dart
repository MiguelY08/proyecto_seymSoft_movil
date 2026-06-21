import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/purchase_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/purchases_repository.dart';

enum PurchasesStatus { initial, loading, success, failure }

class PurchasesState {
  const PurchasesState({
    this.status = PurchasesStatus.initial,
    this.purchases = const [],
    this.details = const {},
    this.loadingDetailIds = const {},
    this.detailErrors = const {},
    this.page = 0,
    this.total = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final PurchasesStatus status;
  final List<Purchase> purchases;
  final Map<int, Purchase> details;
  final Set<int> loadingDetailIds;
  final Map<int, String> detailErrors;
  final int page;
  final int total;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? errorMessage;

  PurchasesState copyWith({
    PurchasesStatus? status,
    List<Purchase>? purchases,
    Map<int, Purchase>? details,
    Set<int>? loadingDetailIds,
    Map<int, String>? detailErrors,
    int? page,
    int? total,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PurchasesState(
      status: status ?? this.status,
      purchases: purchases ?? this.purchases,
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

class PurchasesCubit extends Cubit<PurchasesState> {
  PurchasesCubit(this._repository) : super(const PurchasesState());

  final PurchasesRepository _repository;

  Future<void> loadPurchases({bool refresh = false}) async {
    if (refresh || state.status == PurchasesStatus.initial) {
      emit(const PurchasesState(status: PurchasesStatus.loading));
    } else if (state.isLoadingMore || !state.hasNextPage) {
      return;
    } else {
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    }

    final nextPage = refresh || state.page == 0 ? 1 : state.page + 1;
    try {
      final result = await _repository.getPurchases(page: nextPage);
      emit(
        state.copyWith(
          status: PurchasesStatus.success,
          purchases: nextPage == 1
              ? result.purchases
              : [...state.purchases, ...result.purchases],
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
          status: state.purchases.isEmpty
              ? PurchasesStatus.failure
              : PurchasesStatus.success,
          isLoadingMore: false,
          errorMessage: error.message,
        ),
      );
    }
  }

  Future<void> loadDetail(int purchaseId) async {
    if (state.details.containsKey(purchaseId) ||
        state.loadingDetailIds.contains(purchaseId)) {
      return;
    }

    emit(
      state.copyWith(
        loadingDetailIds: {...state.loadingDetailIds, purchaseId},
        detailErrors: {...state.detailErrors}..remove(purchaseId),
      ),
    );

    try {
      final detail = await _repository.getPurchaseDetail(purchaseId);
      emit(
        state.copyWith(
          details: {...state.details, purchaseId: detail},
          loadingDetailIds: {...state.loadingDetailIds}..remove(purchaseId),
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          loadingDetailIds: {...state.loadingDetailIds}..remove(purchaseId),
          detailErrors: {...state.detailErrors, purchaseId: error.message},
        ),
      );
    }
  }
}
