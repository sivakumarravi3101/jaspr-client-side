import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'dashboard_sidebar.dart';
import 'theme_toggle.dart';

class TradeDashboard extends StatelessComponent {
  const TradeDashboard({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    final activePath = context.url.split('?').first;
    final pageTitle = switch (activePath) {
      '/products' => 'Products',
      '/market-insights' => 'Market Insights',
      '/countries' => 'Countries',
      '/trade-data' => 'Trade Data',
      _ => 'Overview',
    };

    return div(classes: 'trade-app', [
      const DashboardSidebar(),
      div(classes: 'main-area', [
        header(classes: 'topbar', [
          div(classes: 'breadcrumbs', [
            span(classes: 'muted', [.text('Workspace')]),
            span(classes: 'crumb-separator', [.text('/')]),
            span([.text(pageTitle)]),
          ]),
          div(classes: 'topbar-actions', [
            span(classes: 'demo-label', [.text('DEMO DATA')]),
            const ThemeToggle(),
            div(classes: 'top-avatar', [.text('TA')]),
          ]),
        ]),
        main_(classes: 'dashboard-content', [child]),
      ]),
    ]);
  }
}
