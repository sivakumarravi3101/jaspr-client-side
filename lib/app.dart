import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:trade_intelligence/components/trade_dashboard.dart';
import 'package:trade_intelligence/features/products/presentation/export_products_page.dart';

import 'pages/feature_placeholder_page.dart';
import 'pages/overview_page.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        ShellRoute(
          builder: (context, state, child) => TradeDashboard(child: child),
          routes: [
            Route(path: '/', title: 'Overview', builder: (context, state) => const OverviewPage()),
            Route(path: '/products', title: 'Export products', builder: (context, state) => const ExportProductsPage()),
            Route(
              path: '/market-insights',
              title: 'Market insights',
              builder: (context, state) => const FeaturePlaceholderPage(
                title: 'Market insights',
                description: 'Understand demand, market trends, and growth opportunities.',
              ),
            ),
            Route(
              path: '/countries',
              title: 'Countries',
              builder: (context, state) => const FeaturePlaceholderPage(
                title: 'Global markets',
                description: 'Compare destinations and identify promising export markets.',
              ),
            ),
            Route(
              path: '/trade-data',
              title: 'Trade data',
              builder: (context, state) => const FeaturePlaceholderPage(
                title: 'Trade data',
                description: 'Explore trade performance and export activity.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
