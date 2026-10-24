import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/mock_export_products.dart';
import '../models/export_product.dart';

class ExportProductsPage extends StatelessComponent {
  const ExportProductsPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'products-page', [
      // Page heading
      div(classes: 'products-heading', [
        div([
          p(classes: 'products-eyebrow', [
            .text('TRADE INTELLIGENCE / EXPORT DATA'),
          ]),
          p(classes: 'products-title', [
            .text('Export Products'),
          ]),
          p(classes: 'products-subtitle', [
            .text(
              'Explore product-level export records, destinations and ports.',
            ),
          ]),
        ]),
        div(classes: 'products-period', [
          .text('Financial year 2025–26'),
        ]),
      ]),

      // Search and filters
      div(classes: 'products-toolbar', [
        div(classes: 'products-search', [
          p(classes: 'search-symbol', [.text('⌕')]),
          input(
            classes: 'products-search-input',
            name: 'Search product name or HS code...',
          ),
        ]),
        div(classes: 'products-filter', [
          .text('All categories  ▾'),
        ]),
        div(classes: 'products-filter', [
          .text('All destinations  ▾'),
        ]),
        div(classes: 'products-filter', [
          .text('2025–26  ▾'),
        ]),
      ]),

      // Table metadata
      div(classes: 'products-table-card', [
        div(classes: 'products-table-heading', [
          div([
            p(classes: 'table-title', [
              .text('Export records'),
            ]),
            p(classes: 'table-caption', [
              .text('Product and shipment-level details'),
            ]),
          ]),
          div(classes: 'records-count', [
            .text('$mockProductsTotalCount total records'),
          ]),
        ]),

        // Horizontally scrollable table
        div(classes: 'products-table-scroll', [
          div(classes: 'products-table', [
            div(classes: 'products-table-header', [
              _cell('PRODUCT', 'product-col'),
              _cell('HS CODE', 'hs-col'),
              _cell('CATEGORY', 'category-col'),
              _cell('DESTINATION', 'destination-col'),
              _cell('STATE / PORT', 'location-col'),
              _cell('YEAR', 'year-col'),
              _cell('QUANTITY', 'quantity-col'),
              _cell('VALUE', 'value-col'),
            ]),

            ...mockExportProducts.map(_productRow),
          ]),
        ]),

        // Pagination footer
        div(classes: 'products-table-footer', [
          p(classes: 'table-caption', [
            .text(
              'Showing ${mockExportProducts.length} sample record'
              ' · API total: $mockProductsTotalCount',
            ),
          ]),
          div(classes: 'pagination-display', [
            div(classes: 'page-button disabled', [.text('‹')]),
            div(classes: 'page-button current', [
              .text('$mockProductsPageIndex'),
            ]),
            div(classes: 'page-button disabled', [.text('›')]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _cell(String text, String columnClass) {
    return div(classes: 'product-cell $columnClass', [
      p([.text(text)]),
    ]);
  }

  Component _productRow(ExportProduct product) {
    return div(classes: 'products-table-row', [
      div(classes: 'product-cell product-col product-name-cell', [
        p(classes: 'product-name', [
          .text(product.productName),
        ]),
        p(classes: 'product-secondary', [
          .text('Product ID: ${product.productId}'),
        ]),
      ]),
      div(classes: 'product-cell hs-col', [
        p(classes: 'hs-code', [.text(product.hsCode)]),
      ]),
      div(classes: 'product-cell category-col', [
        div(classes: 'category-tag', [
          .text(product.categoryName),
        ]),
      ]),
      div(classes: 'product-cell destination-col', [
        p(classes: 'destination-name', [
          .text(product.countryName),
        ]),
        p(classes: 'product-secondary', [
          .text('Country ID: ${product.countryId}'),
        ]),
      ]),
      div(classes: 'product-cell location-col', [
        p(classes: 'destination-name', [.text(product.state)]),
        p(classes: 'product-secondary', [.text(product.port)]),
      ]),
      div(classes: 'product-cell year-col', [
        p([.text(product.year)]),
      ]),
      div(classes: 'product-cell quantity-col', [
        p(classes: 'numeric-value', [
          .text(product.quantity.toString()),
        ]),
      ]),
      div(classes: 'product-cell value-col', [
        p(classes: 'numeric-value', [
          .text(product.value.toString()),
        ]),
      ]),
    ]);
  }
}
