# trade_intelligence

A new Jaspr project

## Running the project

Run your project using `jaspr serve`.

The development server will be available on `http://localhost:8080`.

## Building the project

Build your project using `jaspr build`.

The output will be located inside the `build/jaspr/` directory.

## Export products

The products page loads records through Dio in `lib/features/products/services/export_product_service.dart`.
Shared API configuration and response/error parsing live under `lib/services/api/`, while the
`lib/features/products/providers/exportproductprovider.dart` StateNotifier handles OData filters and pagination.
The product filters load country and category options from the `countries` and
`categories` endpoints. State, port, and year options are derived from the
currently loaded product records.
