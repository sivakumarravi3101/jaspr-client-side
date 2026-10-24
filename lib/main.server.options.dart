// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:trade_intelligence/components/counter.dart' as _counter;
import 'package:trade_intelligence/components/header.dart' as _header;
import 'package:trade_intelligence/components/trade_dashboard.dart'
    as _trade_dashboard;
import 'package:trade_intelligence/pages/about.dart' as _about;
import 'package:trade_intelligence/pages/home.dart' as _home;
import 'package:trade_intelligence/app.dart' as _app;

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
    _trade_dashboard.TradeDashboard:
        ClientTarget<_trade_dashboard.TradeDashboard>('trade_dashboard'),
    _about.About: ClientTarget<_about.About>('about'),
    _home.Home: ClientTarget<_home.Home>('home'),
  },
  styles: () => [
    ..._app.App.styles,
    ..._counter.CounterState.styles,
    ..._header.Header.styles,
    ..._about.About.styles,
  ],
);
