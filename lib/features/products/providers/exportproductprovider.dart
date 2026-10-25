import 'package:jaspr_riverpod/legacy.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

import 'package:trade_intelligence/features/products/models/export_product.dart';
import 'package:trade_intelligence/features/products/models/lookup_option.dart';
import 'package:trade_intelligence/features/products/services/export_product_service.dart';
import 'package:trade_intelligence/services/api/api_client.dart';
import 'package:trade_intelligence/services/api/api_error.dart';
import 'package:trade_intelligence/services/api/api_error_code.dart';

enum ProductFilterField {
  category,
  destination,
  state,
  port,
  year;

  String get odataField => switch (this) {
    ProductFilterField.category => 'categoryId',
    ProductFilterField.destination => 'countryId',
    ProductFilterField.state => 'state',
    ProductFilterField.port => 'port',
    ProductFilterField.year => 'year',
  };
}

final exportProductServiceProvider = Provider<ExportProductService>(
  (ref) => ExportProductService(ApiClient()),
);

final exportProductProvider = StateNotifierProvider<ExportProductNotifier, ExportProductState>(
  (ref) => ExportProductNotifier(ref.watch(exportProductServiceProvider)),
);

class ExportProductState {
  const ExportProductState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.filterErrorMessage,
    this.totalCount = 0,
    this.pageIndex = 1,
    this.pageSize = 10,
    this.searchQuery = '',
    this.categories = const [],
    this.countries = const [],
    this.isLoadingFilters = false,
    this.selectedCategoryId = '',
    this.selectedCountryId = '',
    this.selectedState = '',
    this.selectedPort = '',
    this.selectedYear = '',
    this.activeFilter,
  });

  final List<ExportProduct> products;
  final bool isLoading;
  final String? errorMessage;
  final String? filterErrorMessage;
  final int totalCount;
  final int pageIndex;
  final int pageSize;
  final String searchQuery;
  final List<LookupOption> categories;
  final List<LookupOption> countries;
  final bool isLoadingFilters;
  final String selectedCategoryId;
  final String selectedCountryId;
  final String selectedState;
  final String selectedPort;
  final String selectedYear;
  final ProductFilterField? activeFilter;

  bool get hasPreviousPage => pageIndex > 1;
  bool get hasNextPage => pageIndex * pageSize < totalCount;

  ExportProductState copyWith({
    List<ExportProduct>? products,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? filterErrorMessage,
    bool clearFilterError = false,
    int? totalCount,
    int? pageIndex,
    int? pageSize,
    String? searchQuery,
    List<LookupOption>? categories,
    List<LookupOption>? countries,
    bool? isLoadingFilters,
    String? selectedCategoryId,
    String? selectedCountryId,
    String? selectedState,
    String? selectedPort,
    String? selectedYear,
    ProductFilterField? activeFilter,
    bool clearActiveFilter = false,
  }) {
    return ExportProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      filterErrorMessage: clearFilterError ? null : filterErrorMessage ?? this.filterErrorMessage,
      totalCount: totalCount ?? this.totalCount,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      countries: countries ?? this.countries,
      isLoadingFilters: isLoadingFilters ?? this.isLoadingFilters,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      selectedState: selectedState ?? this.selectedState,
      selectedPort: selectedPort ?? this.selectedPort,
      selectedYear: selectedYear ?? this.selectedYear,
      activeFilter: clearActiveFilter ? null : activeFilter ?? this.activeFilter,
    );
  }
}

class ExportProductNotifier extends StateNotifier<ExportProductState> {
  ExportProductNotifier(this._service) : super(const ExportProductState());

  final ExportProductService _service;
  int _requestId = 0;

  Future<void> loadFilterOptions() async {
    state = state.copyWith(isLoadingFilters: true, clearFilterError: true);
    try {
      final results = await Future.wait<List<LookupOption>>([
        _service.getCountries(),
        _service.getCategories(),
      ]);
      state = state.copyWith(
        countries: results[0],
        categories: results[1],
        isLoadingFilters: false,
        clearFilterError: true,
      );
    } on ApiError catch (error) {
      state = state.copyWith(
        isLoadingFilters: false,
        filterErrorMessage: error.responseMessage,
      );
    } on FormatException catch (error) {
      state = state.copyWith(
        isLoadingFilters: false,
        filterErrorMessage: error.message,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingFilters: false,
        filterErrorMessage: 'Unable to load product filters: $error',
      );
    }
  }

  Future<void> loadProducts({int? pageIndex}) async {
    final requestId = ++_requestId;
    final targetPage = pageIndex ?? state.pageIndex;
    state = state.copyWith(
      isLoading: true,
      pageIndex: targetPage,
      clearError: true,
    );

    try {
      final response = await _service.getProducts(
        filter: _buildODataFilter(),
        top: state.pageSize,
        skip: (targetPage - 1) * state.pageSize,
      );
      if (requestId != _requestId) return;
      state = state.copyWith(
        products: response.items,
        totalCount: response.totalCount,
        pageIndex: response.pageIndex,
        pageSize: response.pageSize,
        isLoading: false,
        clearError: true,
        clearActiveFilter: true,
      );
    } on ApiError catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.responseMessage,
      );
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      );
    } catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiError(
          code: ApiErrorCode.unknown,
          responseMessage: 'Unable to load export products: $error',
        ).responseMessage,
      );
    }
  }

  void setSearchQuery(String value) {
    final shouldReloadAll = state.searchQuery.trim().isNotEmpty && value.trim().isEmpty;
    state = state.copyWith(searchQuery: value);
    if (shouldReloadAll) {
      loadProducts(pageIndex: 1);
    }
  }

  Future<void> applySearch() => loadProducts(pageIndex: 1);

  Future<void> setCategory(String categoryId) async {
    state = state.copyWith(selectedCategoryId: categoryId);
    await loadProducts(pageIndex: 1);
  }

  Future<void> setDestination(String countryId) async {
    state = state.copyWith(selectedCountryId: countryId);
    await loadProducts(pageIndex: 1);
  }

  Future<void> setStateFilter(String value) async {
    state = state.copyWith(selectedState: value);
    await loadProducts(pageIndex: 1);
  }

  Future<void> setPortFilter(String value) async {
    state = state.copyWith(selectedPort: value);
    await loadProducts(pageIndex: 1);
  }

  Future<void> setYearFilter(String value) async {
    state = state.copyWith(selectedYear: value);
    await loadProducts(pageIndex: 1);
  }

  void toggleFilter(ProductFilterField field) {
    state = state.copyWith(
      activeFilter: state.activeFilter == field ? null : field,
      clearActiveFilter: state.activeFilter == field,
    );
  }

  Future<void> goToPreviousPage() async {
    if (state.hasPreviousPage && !state.isLoading) {
      await loadProducts(pageIndex: state.pageIndex - 1);
    }
  }

  Future<void> goToNextPage() async {
    if (state.hasNextPage && !state.isLoading) {
      await loadProducts(pageIndex: state.pageIndex + 1);
    }
  }

  String _buildODataFilter() {
    final clauses = <String>[];
    final query = state.searchQuery.trim();
    if (query.isNotEmpty) {
      final escapedQuery = _escapeODataString(query);
      clauses.add(
        "(contains(productName,'$escapedQuery') or contains(hsCode,'$escapedQuery'))",
      );
    }
    if (state.selectedCategoryId.isNotEmpty) {
      clauses.add('${ProductFilterField.category.odataField} eq ${state.selectedCategoryId}');
    }
    if (state.selectedCountryId.isNotEmpty) {
      clauses.add('${ProductFilterField.destination.odataField} eq ${state.selectedCountryId}');
    }
    if (state.selectedState.isNotEmpty) {
      clauses.add(
        "${ProductFilterField.state.odataField} eq '${_escapeODataString(state.selectedState)}'",
      );
    }
    if (state.selectedPort.isNotEmpty) {
      clauses.add(
        "${ProductFilterField.port.odataField} eq '${_escapeODataString(state.selectedPort)}'",
      );
    }
    if (state.selectedYear.isNotEmpty) {
      clauses.add(
        "${ProductFilterField.year.odataField} eq '${_escapeODataString(state.selectedYear)}'",
      );
    }
    return clauses.join(' and ');
  }

  String _escapeODataString(String value) => value.replaceAll("'", "''");
}
