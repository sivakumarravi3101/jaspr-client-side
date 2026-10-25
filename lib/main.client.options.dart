// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:trade_intelligence/components/theme_toggle.dart'
    deferred as _theme_toggle;
import 'package:trade_intelligence/features/products/presentation/export_products_page.dart'
    deferred as _export_products_page;
import 'package:trade_intelligence/pages/overview_page.dart'
    deferred as _overview_page;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'theme_toggle': ClientLoader(
      (p) => _theme_toggle.ThemeToggle(),
      loader: _theme_toggle.loadLibrary,
    ),
    'export_products_page': ClientLoader(
      (p) => _export_products_page.ExportProductsPage(),
      loader: _export_products_page.loadLibrary,
    ),
    'overview_page': ClientLoader(
      (p) => _overview_page.OverviewPage(),
      loader: _overview_page.loadLibrary,
    ),
  },
);
