// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:trade_intelligence/components/theme_toggle.dart'
    as _theme_toggle;
import 'package:trade_intelligence/features/products/presentation/export_products_page.dart'
    as _export_products_page;
import 'package:trade_intelligence/pages/overview_page.dart' as _overview_page;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _theme_toggle.ThemeToggle: ClientTarget<_theme_toggle.ThemeToggle>(
      'theme_toggle',
    ),
    _export_products_page.ExportProductsPage:
        ClientTarget<_export_products_page.ExportProductsPage>(
          'export_products_page',
        ),
    _overview_page.OverviewPage: ClientTarget<_overview_page.OverviewPage>(
      'overview_page',
    ),
  },
  styles: () => [],
);
