import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

@client
class OverviewPage extends StatelessComponent {
  const OverviewPage({super.key});

  static const _markets = [
    (country: 'United States', code: 'US', product: 'Textiles & apparel', value: '\$2.84M', change: '+12.8%'),
    (country: 'United Arab Emirates', code: 'AE', product: 'Processed foods', value: '\$1.62M', change: '+8.4%'),
    (country: 'Germany', code: 'DE', product: 'Engineering goods', value: '\$1.28M', change: '+6.2%'),
    (country: 'Singapore', code: 'SG', product: 'Organic chemicals', value: '\$940K', change: '+4.9%'),
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'overview-page', [
      div(classes: 'page-heading', [
        div([
          div(classes: 'eyebrow', [.text('TRADE INTELLIGENCE / 2026')]),
          h1([.text('Good evening, Analyst')]),
          p(classes: 'page-description', [
            .text('Here is your export performance and market outlook.'),
          ]),
        ]),
        button(classes: 'primary-button', [
          span([.text('↓')]),
          span([.text('Export report')]),
        ]),
      ]),
      div(classes: 'kpi-grid', [
        _kpi('Total export value', '\$8.42M', '+12.6%', 'vs. previous period', '↗', 'blue'),
        _kpi('Active markets', '24', '+3', 'new markets this quarter', '◎', 'purple'),
        _kpi('Tracked products', '186', '+18', 'products monitored', '▦', 'orange'),
        _kpi('Avg. market growth', '8.4%', '+2.1%', 'vs. previous period', '↗', 'green'),
      ]),
      div(classes: 'content-grid', [
        section(classes: 'panel chart-panel', [
          div(classes: 'panel-heading', [
            div([
              h2([.text('Export performance')]),
              p(classes: 'muted small', [.text('Monthly export value across tracked markets')]),
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
            ...['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'].map((month) => span([.text(month)])),
          ]),
        ]),
        section(classes: 'panel insights-panel', [
          div(classes: 'panel-heading', [
            div([
              h2([.text('Market pulse')]),
              p(classes: 'muted small', [.text('Highlights from your markets')]),
            ]),
            span(classes: 'insight-spark', [.text('✦')]),
          ]),
          _insight('↗', 'Strong demand', 'Textile exports to the US are trending upward.', 'blue'),
          _insight('◎', 'Emerging opportunity', 'UAE food imports show positive growth.', 'green'),
          _insight('!', 'Keep an eye on', 'Freight costs may affect European margins.', 'orange'),
          Link(
            to: '/market-insights',
            classes: 'text-button',
            children: [
              span([.text('View market insights')]),
              span([.text('→')]),
            ],
          ),
        ]),
      ]),
      section(classes: 'panel markets-panel', [
        div(classes: 'panel-heading table-heading', [
          div([
            h2([.text('Top export markets')]),
            p(classes: 'muted small', [.text('Performance across your tracked destinations')]),
          ]),
          Link(to: '/countries', classes: 'secondary-button', child: .text('View all markets →')),
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
              ..._markets.map(
                (market) => tr([
                  td([
                    div(classes: 'country-cell', [
                      div(classes: 'country-code', [.text(market.code)]),
                      span([.text(market.country)]),
                    ]),
                  ]),
                  td([
                    span(classes: 'product-name', [.text(market.product)]),
                  ]),
                  td([
                    strong(classes: 'value-cell', [.text(market.value)]),
                  ]),
                  td([
                    span(classes: 'growth-pill', [.text('↗ ${market.change}')]),
                  ]),
                ]),
              ),
            ]),
          ]),
        ]),
        div(classes: 'table-footer', [
          span(classes: 'muted small', [.text('Showing 4 of 24 tracked markets')]),
          span(classes: 'muted small', [.text('Illustrative figures · Not live data')]),
        ]),
      ]),
      footer(classes: 'dashboard-footer', [
        span([.text('TradePilot Intelligence')]),
        span([.text('Dashboard preview · API integration pending')]),
      ]),
    ]);
  }

  Component _kpi(String label, String value, String change, String caption, String symbol, String color) {
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

  Component _insight(String symbol, String title, String description, String color) {
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
            attributes: {'d': 'M $path L 396,140 L 0,140 Z', 'class': 'chart-area'},
            children: [],
          ),
          Component.element(
            tag: 'path',
            attributes: {'d': 'M $path', 'class': 'chart-line'},
            children: [],
          ),
        ],
      ),
    ]);
  }
}
