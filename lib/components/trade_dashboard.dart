import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:trade_intelligence/features/products/presentation/export_porducts_page.dart';

@client
class TradeDashboard extends StatefulComponent {
  const TradeDashboard({super.key});

  @override
  State<TradeDashboard> createState() => TradeDashboardState();
}

class TradeDashboardState extends State<TradeDashboard> {
  bool isDark = false;
  String selectedNav = 'Overview';

  final List<Map<String, String>> markets = [
    {
      'country': 'United States',
      'code': 'US',
      'product': 'Textiles & apparel',
      'value': '\$2.84M',
      'change': '+12.8%',
    },
    {
      'country': 'United Arab Emirates',
      'code': 'AE',
      'product': 'Processed foods',
      'value': '\$1.62M',
      'change': '+8.4%',
    },
    {
      'country': 'Germany',
      'code': 'DE',
      'product': 'Engineering goods',
      'value': '\$1.28M',
      'change': '+6.2%',
    },
    {
      'country': 'Singapore',
      'code': 'SG',
      'product': 'Organic chemicals',
      'value': '\$940K',
      'change': '+4.9%',
    },
  ];

  @override
  Component build(BuildContext context) {
    final theme = isDark ? 'dark' : 'light';

    return div(classes: 'trade-app $theme', [
      // Sidebar
      aside(classes: 'sidebar', [
        div(classes: 'brand', [
          div(classes: 'brand-icon', [
            span([.text('T')]),
          ]),
          div([
            div(classes: 'brand-name', [
              .text('TradePilot'),
            ]),
            div(classes: 'brand-subtitle', [
              .text('INTELLIGENCE'),
            ]),
          ]),
        ]),
        div(classes: 'workspace-label', [
          .text('WORKSPACE'),
        ]),
        ...[
          ['Overview', '◫'],
          ['Products', '▦'],
          ['Market Insights', '↗'],
          ['Countries', '◎'],
          ['Trade Data', '⇄'],
        ].map((item) {
          final active = selectedNav == item[0];
          return button(
            classes: 'nav-item ${active ? 'active' : ''}',
            onClick: () => setState(() {
              selectedNav = item[0];
            }),
            [
              span(classes: 'nav-icon', [.text(item[1])]),
              span([.text(item[0])]),
              if (item[0] == 'Market Insights') span(classes: 'nav-badge', [.text('3')]),
            ],
          );
        }),
        div(classes: 'sidebar-bottom', [
          div(classes: 'sidebar-help', [
            div(classes: 'help-symbol', [.text('?')]),
            div(classes: 'help-copy', [
              div([.text('Need help?')]),
              div(classes: 'muted small', [
                .text('Explore the user guide'),
              ]),
            ]),
          ]),
          div(classes: 'profile', [
            div(classes: 'avatar', [.text('TI')]),
            div(classes: 'profile-copy', [
              div(classes: 'profile-name', [.text('Trade Analyst')]),
              div(classes: 'muted small', [.text('Workspace member')]),
            ]),
            span(classes: 'profile-menu', [.text('···')]),
          ]),
        ]),
      ]),

      // Main content
      div(classes: 'main-area', [
        header(classes: 'topbar', [
          div(classes: 'breadcrumbs', [
            span(classes: 'muted', [.text('Workspace')]),
            span(classes: 'crumb-separator', [.text('/')]),
            span([.text(selectedNav)]),
          ]),
          div(classes: 'topbar-actions', [
            span(classes: 'demo-label', [.text('DEMO DATA')]),
            button(
              classes: 'icon-button theme-button',
              //title: 'Toggle light and dark theme',
              onClick: () => setState(() {
                isDark = !isDark;
              }),
              [
                span([.text(isDark ? '☀' : '☾')]),
              ],
            ),
            div(classes: 'top-avatar', [.text('TA')]),
          ]),
        ]),

        div(classes: 'dashboard-content', [
          if (selectedNav == 'Products')
            const ExportProductsPage()
          else
            div(classes: 'page-heading', [
              div([
                div(classes: 'eyebrow', [
                  .text('TRADE INTELLIGENCE / 2026'),
                ]),
                h1([.text(_pageTitle())]),
                p(classes: 'page-description', [
                  .text(_pageDescription()),
                ]),
              ]),
              button(
                classes: 'primary-button',
                onClick: () {
                  // Export functionality will be added in a later phase.
                },
                [
                  span([.text('↓')]),
                  span([.text('Export report')]),
                ],
              ),
            ]),

          // KPI cards
          div(classes: 'kpi-grid', [
            _kpi(
              'Total export value',
              '\$8.42M',
              '+12.6%',
              'vs. previous period',
              '↗',
              'blue',
            ),
            _kpi(
              'Active markets',
              '24',
              '+3',
              'new markets this quarter',
              '◎',
              'purple',
            ),
            _kpi(
              'Tracked products',
              '186',
              '+18',
              'products monitored',
              '▦',
              'orange',
            ),
            _kpi(
              'Avg. market growth',
              '8.4%',
              '+2.1%',
              'vs. previous period',
              '↗',
              'green',
            ),
          ]),

          // Chart and market summary
          div(classes: 'content-grid', [
            section(classes: 'panel chart-panel', [
              div(classes: 'panel-heading', [
                div([
                  h2([.text('Export performance')]),
                  p(classes: 'muted small', [
                    .text('Monthly export value across tracked markets'),
                  ]),
                ]),
                span(classes: 'period-chip', [.text('Last 6 months ▾')]),
              ]),
              div(classes: 'chart-summary', [
                strong([.text('\$8.42M')]),
                span(classes: 'positive', [.text('↗ 12.6%')]),
              ]),
              div(classes: 'chart-legend', [
                span(classes: 'legend-dot', []),
                span(classes: 'muted small', [.text('Export value')]),
              ]),
              _chart(),
              div(classes: 'chart-months', [
                ...['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'].map(
                  (month) => span([.text(month)]),
                ),
              ]),
            ]),

            section(classes: 'panel insights-panel', [
              div(classes: 'panel-heading', [
                div([
                  h2([.text('Market pulse')]),
                  p(classes: 'muted small', [
                    .text('Highlights from your markets'),
                  ]),
                ]),
                span(classes: 'insight-spark', [.text('✦')]),
              ]),
              _insight(
                '↗',
                'Strong demand',
                'Textile exports to the US are trending upward.',
                'blue',
              ),
              _insight(
                '◎',
                'Emerging opportunity',
                'UAE food imports show positive growth.',
                'green',
              ),
              _insight(
                '!',
                'Keep an eye on',
                'Freight costs may affect European margins.',
                'orange',
              ),
              button(
                classes: 'text-button',
                onClick: () => setState(() {
                  selectedNav = 'Market Insights';
                }),
                [
                  span([.text('View market insights')]),
                  span([.text('→')]),
                ],
              ),
            ]),
          ]),

          // Markets table
          section(classes: 'panel markets-panel', [
            div(classes: 'panel-heading table-heading', [
              div([
                h2([.text('Top export markets')]),
                p(classes: 'muted small', [
                  .text('Performance across your tracked destinations'),
                ]),
              ]),
              button(
                classes: 'secondary-button',
                onClick: () => setState(() {
                  selectedNav = 'Countries';
                }),
                [.text('View all markets →')],
              ),
            ]),
            div(classes: 'table-scroll', [
              table(classes: 'markets-table', [
                thead([
                  tr([
                    th([.text('MARKET')]),
                    th([.text('TOP PRODUCT')]),
                    th([.text('EXPORT VALUE')]),
                    th([.text('GROWTH')]),
                  ]),
                ]),
                tbody([
                  ...markets.map((market) {
                    return tr([
                      td([
                        div(classes: 'country-cell', [
                          div(classes: 'country-code', [
                            .text(market['code']!),
                          ]),
                          span([.text(market['country']!)]),
                        ]),
                      ]),
                      td([
                        span(classes: 'product-name', [
                          .text(market['product']!),
                        ]),
                      ]),
                      td([
                        strong(classes: 'value-cell', [
                          .text(market['value']!),
                        ]),
                      ]),
                      td([
                        span(classes: 'growth-pill', [
                          .text('↗ ${market['change']}'),
                        ]),
                      ]),
                    ]);
                  }),
                ]),
              ]),
            ]),
            div(classes: 'table-footer', [
              span(classes: 'muted small', [
                .text('Showing 4 of 24 tracked markets'),
              ]),
              span(classes: 'muted small', [
                .text('Illustrative figures · Not live data'),
              ]),
            ]),
          ]),

          footer(classes: 'dashboard-footer', [
            span([.text('TradePilot Intelligence')]),
            span([.text('Dashboard preview · API integration pending')]),
          ]),
        ]),
      ]),
    ]);
  }

  String _pageTitle() {
    switch (selectedNav) {
      case 'Products':
        return 'Export products';
      case 'Market Insights':
        return 'Market insights';
      case 'Countries':
        return 'Global markets';
      case 'Trade Data':
        return 'Trade data';
      default:
        return 'Good evening, Analyst';
    }
  }

  String _pageDescription() {
    switch (selectedNav) {
      case 'Products':
        return 'Monitor your products and discover export opportunities.';
      case 'Market Insights':
        return 'Understand demand, market trends, and growth opportunities.';
      case 'Countries':
        return 'Compare destinations and identify promising export markets.';
      case 'Trade Data':
        return 'Explore trade performance and export activity.';
      default:
        return 'Here is your export performance and market outlook.';
    }
  }

  Component _kpi(
    String label,
    String value,
    String change,
    String caption,
    String symbol,
    String color,
  ) {
    return div(classes: 'kpi-card', [
      div(classes: 'kpi-top', [
        span(classes: 'kpi-label', [.text(label)]),
        div(classes: 'kpi-icon $color', [.text(symbol)]),
      ]),
      div(classes: 'kpi-value', [.text(value)]),
      div(classes: 'kpi-bottom', [
        span(classes: 'positive', [.text('↗ $change')]),
        span(classes: 'muted small', [.text(caption)]),
      ]),
    ]);
  }

  Component _insight(
    String symbol,
    String title,
    String description,
    String color,
  ) {
    return div(classes: 'insight-row', [
      div(classes: 'insight-icon $color', [.text(symbol)]),
      div(classes: 'insight-copy', [
        strong([.text(title)]),
        p([.text(description)]),
      ]),
    ]);
  }

  Component _chart() {
    final points = [
      [0, 108],
      [1, 91],
      [2, 101],
      [3, 66],
      [4, 76],
      [5, 48],
      [6, 61],
      [7, 35],
      [8, 46],
      [9, 22],
      [10, 32],
      [11, 12],
    ];

    final path = points.map((point) => '${point[0] * 36},${point[1]}').join(' L ');

    return div(classes: 'chart-wrap', [
      Component.element(
        tag: 'svg',
        attributes: {
          'viewBox': '0 0 396 140',
          'preserveAspectRatio': 'none',
          'role': 'img',
          'aria-label': 'Illustrative export trend chart',
        },
        children: [
          ...[25, 60, 95, 130].map(
            (y) => Component.element(
              tag: 'line',
              attributes: {
                'x1': '0',
                'y1': '$y',
                'x2': '396',
                'y2': '$y',
                'class': 'chart-gridline',
              },
              children: [],
            ),
          ),
          Component.element(
            tag: 'path',
            attributes: {
              'd': 'M $path L 396,140 L 0,140 Z',
              'class': 'chart-area',
            },
            children: [],
          ),
          Component.element(
            tag: 'path',
            attributes: {
              'd': 'M $path',
              'class': 'chart-line',
            },
            children: [],
          ),
        ],
      ),
    ]);
  }
}
