import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/export_product.dart';
import '../providers/exportproductprovider.dart';

@client
class ExportProductsPage extends StatefulComponent {
  const ExportProductsPage({super.key});

  @override
  State<ExportProductsPage> createState() => ExportProductsPageState();
}

class ExportProductsPageState extends State<ExportProductsPage> {
  bool _hasRequestedProducts = false;

  @override
  void initState() {
    super.initState();
    // initState runs on the server during SSR AND on the client during hydration.
    // By checking kIsWeb here, we ensure it ONLY fires when running in the actual browser!
    if (kIsWeb) {
      Future.microtask(() {
        final notifier = context.read(exportProductProvider.notifier);
        notifier.loadProducts();
        notifier.loadFilterOptions();
      });
    }
  }

  final List<String> _years = ["2020-21", "2021-22", "2022-23", "2023-24", "2024-25", "2025-26", "2026-27"];
  @override
  Component build(BuildContext context) {
    final state = context.watch(exportProductProvider);
    final notifier = context.read(exportProductProvider.notifier);
    final categories = state.categories.map((category) => ('${category.id}', category.name)).toList(growable: false);
    final states = _uniqueValues(state.products.map((product) => product.state));
    final ports = _uniqueValues(state.products.map((product) => product.port));
    //final years = _uniqueValues(state.products.map((product) => product.year));
    final totalValue = state.products.fold<num>(0, (total, product) => total + product.value);
    final totalQuantity = state.products.fold<num>(0, (total, product) => total + product.quantity);

    return div(classes: 'products-page', [
      div(classes: 'products-heading', [
        div([
          p(classes: 'products-eyebrow', [.text('TRADE INTELLIGENCE / EXPORT DATA')]),
          h1(classes: 'products-title', [.text('Export products')]),
          p(classes: 'products-subtitle', [
            .text('Explore product-level export records, destinations, and ports.'),
          ]),
        ]),
      ]),
      div(classes: 'products-summary-grid', [
        // _summaryCard('Products on page', '${state.products.length}', 'Records in this result page', '▤', 'blue'),
        _summaryCard('Export value', totalValue.toStringAsFixed(2), 'Total on this page', '↗', 'purple'),
        _summaryCard('Export quantity', totalQuantity.toStringAsFixed(2), 'Total on this page', '▦', 'green'),
        //_summaryCard('Page', '${state.pageIndex}', 'Page size ${state.pageSize}', '◎', 'orange'),
      ]),
      div(classes: 'products-toolbar', [
        label(
          classes: 'products-search',
          attributes: {'for': 'product-search'},
          [
            span(classes: 'search-symbol', [.text('⌕')]),
            input<String>(
              id: 'product-search',
              classes: 'products-search-input',
              name: 'search',
              type: InputType.search,
              value: state.searchQuery,
              onInput: notifier.setSearchQuery,
              onChange: (_) => notifier.applySearch(),
              attributes: {
                'aria-label': 'Search product name or HS code',
                'placeholder': 'Search product name or HS code',
              },
            ),
          ],
        ),
        button(
          classes: 'primary-button products-search-button',
          type: ButtonType.button,
          disabled: state.isLoading,
          onClick: notifier.applySearch,
          [
            span([.text('⌕')]),
            span([.text('Search')]),
          ],
        ),
      ]),
      if (state.errorMessage case final error?)
        div(
          classes: 'products-error',
          attributes: {'role': 'alert'},
          [
            div([
              strong([.text('Could not load export products')]),
              p([.text(error)]),
            ]),
            button(
              classes: 'secondary-button',
              type: ButtonType.button,
              onClick: () => notifier.loadProducts(),
              [.text('Retry')],
            ),
          ],
        ),
      div(classes: 'products-table-card', [
        div(classes: 'products-table-heading', [
          div([
            h2(classes: 'table-title', [.text('Export records')]),
            p(classes: 'table-caption', [
              .text('Product and shipment-level details · ${state.totalCount} matching records'),
            ]),
          ]),
          if (state.isLoading)
            div(classes: 'records-count loading-count', [
              span(classes: 'loading-indicator', []),
              .text('Loading records'),
            ])
          else
            div(classes: 'records-count', [
              span(classes: 'records-count-dot', []),
              .text('${state.products.length} shown'),
            ]),
        ]),
        div(classes: 'products-table-scroll', [
          div(classes: 'products-table', [
            div(classes: 'products-table-header', [
              _cell('PRODUCT', 'product-col'),
              _cell('HS CODE', 'hs-col'),
              _filterHeader(
                context,
                state,
                'CATEGORY',
                ProductFilterField.category,
                categories,
                state.selectedCategoryId,
                notifier.setCategory,
              ),
              _filterHeader(
                context,
                state,
                'DESTINATION',
                ProductFilterField.destination,
                state.countries.map((country) => ('${country.id}', country.name)).toList(growable: false),
                state.selectedCountryId,
                notifier.setDestination,
              ),
              _filterHeader(
                context,
                state,
                'STATE',
                ProductFilterField.state,
                states.map((value) => (value, value)).toList(),
                state.selectedState,
                notifier.setStateFilter,
              ),
              _filterHeader(
                context,
                state,
                'PORT',
                ProductFilterField.port,
                ports.map((value) => (value, value)).toList(),
                state.selectedPort,
                notifier.setPortFilter,
              ),
              _filterHeader(
                context,
                state,
                'YEAR',
                ProductFilterField.year,
                _years.map((value) => (value, value)).toList(),
                state.selectedYear,
                notifier.setYearFilter,
              ),
              //_cell('YEAR', 'year-col'),
              _cell('QUANTITY', 'quantity-col'),
              _cell('VALUE', 'value-col'),
            ]),
            if (state.products.isEmpty && !state.isLoading)
              div(classes: 'products-empty-state', [
                strong([.text(state.errorMessage == null ? 'No matching export products' : 'No records to display')]),
                p(classes: 'table-caption', [
                  .text('Try changing the search or table filters.'),
                ]),
              ])
            else
              ...state.products.map(_productRow),
          ]),
        ]),
        div(classes: 'products-table-footer', [
          p(classes: 'table-caption', [
            .text(
              'Showing ${state.products.length} of ${state.totalCount} records · '
              'Page ${state.pageIndex} of ${_pageCount(state.totalCount, state.pageSize)}',
            ),
          ]),
          div(classes: 'pagination-display', [
            button(
              classes: 'page-button',
              type: ButtonType.button,
              disabled: !state.hasPreviousPage || state.isLoading,
              attributes: {'aria-label': 'Previous page'},
              onClick: notifier.goToPreviousPage,
              [.text('‹')],
            ),
            span(
              classes: 'page-button current',
              attributes: {'aria-current': 'page'},
              [
                .text('${state.pageIndex}'),
              ],
            ),
            button(
              classes: 'page-button',
              type: ButtonType.button,
              disabled: !state.hasNextPage || state.isLoading,
              attributes: {'aria-label': 'Next page'},
              onClick: notifier.goToNextPage,
              [.text('›')],
            ),
          ]),
        ]),
      ]),
    ]);
  }

  int _pageCount(int totalCount, int pageSize) {
    if (totalCount == 0 || pageSize == 0) return 1;
    return (totalCount + pageSize - 1) ~/ pageSize;
  }

  List<String> _uniqueValues(Iterable<String> values) {
    final result = values.toSet().toList()..sort();
    return result;
  }

  Component _summaryCard(String label, String value, String note, String icon, String color) {
    return div(classes: 'product-summary-card', [
      div(classes: 'product-summary-top', [
        span(classes: 'product-summary-label', [.text(label)]),
        span(classes: 'product-summary-icon $color', [.text(icon)]),
      ]),
      strong(classes: 'product-summary-value', [.text(value)]),
      span(classes: 'product-summary-note', [.text(note)]),
    ]);
  }

  Component _cell(String text, String columnClass) {
    return div(classes: 'product-cell $columnClass', [
      p([.text(text)]),
    ]);
  }

  Component _filterHeader(
    BuildContext context,
    ExportProductState state,
    String label,
    ProductFilterField field,
    List<(String, String)> options,
    String selectedValue,
    Future<void> Function(String) onChanged,
  ) {
    final isOpen = state.activeFilter == field;
    return div(classes: 'product-cell product-header-filter ${_columnClass(field)}', [
      div(classes: 'filter-heading-label', [
        span([.text(label)]),
        button(
          classes: 'header-filter-button ${selectedValue.isNotEmpty ? 'selected' : ''}',
          type: ButtonType.button,
          attributes: {
            'aria-label': 'Filter by ${label.toLowerCase()}',
            'aria-expanded': '$isOpen',
          },
          onClick: () => context.read(exportProductProvider.notifier).toggleFilter(field),
          [
            span(classes: 'funnel-icon', [.text('▽')]),
          ],
        ),
      ]),
      if (isOpen)
        div(classes: 'header-filter-menu', [
          select(
            classes: 'header-filter-select',
            value: selectedValue,
            attributes: {'aria-label': 'Select ${label.toLowerCase()} filter'},
            onChange: (values) {
              final value = values.isEmpty ? '' : values.first;
              onChanged(value);
            },
            [
              option([.text('All ${label.toLowerCase()}')], value: '', selected: selectedValue.isEmpty),
              ...options.map(
                (item) => option(
                  [.text(item.$2)],
                  value: item.$1,
                  selected: selectedValue == item.$1,
                ),
              ),
            ],
          ),
        ]),
    ]);
  }

  String _columnClass(ProductFilterField field) {
    return switch (field) {
      ProductFilterField.category => 'category-col',
      ProductFilterField.destination => 'destination-col',
      ProductFilterField.state => 'state-col',
      ProductFilterField.port => 'port-col',
      ProductFilterField.year => 'year-col',
    };
  }

  Component _productRow(ExportProduct product) {
    return div(classes: 'products-table-row', [
      div(classes: 'product-cell product-col product-name-cell', [
        p(classes: 'product-name', [.text(product.productName)]),
        p(classes: 'product-secondary', [.text('Product ID: ${product.productId}')]),
      ]),
      div(classes: 'product-cell hs-col', [
        p(classes: 'hs-code', [.text(product.hsCode)]),
      ]),
      div(classes: 'product-cell category-col', [
        span(classes: 'category-tag', [.text(product.categoryName)]),
      ]),
      div(classes: 'product-cell destination-col', [
        p(classes: 'destination-name', [.text(product.countryName)]),
        p(classes: 'product-secondary', [.text('Country ID: ${product.countryId}')]),
      ]),
      div(classes: 'product-cell state-col', [
        p(classes: 'destination-name', [.text(product.state)]),
      ]),
      div(classes: 'product-cell port-col', [
        p(classes: 'product-secondary port-name', [.text(product.port)]),
      ]),
      div(classes: 'product-cell year-col', [
        p([.text(product.year)]),
      ]),
      div(classes: 'product-cell quantity-col', [
        p(classes: 'numeric-value', [.text(product.quantity.toString())]),
      ]),
      div(classes: 'product-cell value-col', [
        p(classes: 'numeric-value', [.text(product.value.toString())]),
      ]),
    ]);
  }
}
