import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class DashboardSidebar extends StatelessComponent {
  const DashboardSidebar({super.key});

  static const _items = [
    (label: 'Overview', path: '/', icon: '◫'),
    (label: 'Products', path: '/products', icon: '▦'),
    (label: 'Market Insights', path: '/market-insights', icon: '↗'),
    (label: 'Countries', path: '/countries', icon: '◎'),
    (label: 'Trade Data', path: '/trade-data', icon: '⇄'),
  ];

  @override
  Component build(BuildContext context) {
    final activePath = context.url.split('?').first;

    return aside(classes: 'sidebar', [
      Link(
        to: '/',
        classes: 'brand',
        attributes: {'aria-label': 'TradePilot home'},
        children: [
          div(classes: 'brand-icon', [
            span([.text('T')]),
          ]),
          div([
            div(classes: 'brand-name', [.text('TradePilot')]),
            div(classes: 'brand-subtitle', [.text('INTELLIGENCE')]),
          ]),
        ],
      ),
      div(classes: 'workspace-label', [.text('WORKSPACE')]),
      nav(
        classes: 'sidebar-navigation',
        attributes: {'aria-label': 'Main navigation'},
        [
          ..._items.map((item) {
            final active = activePath == item.path;
            return Link(
              to: item.path,
              classes: 'nav-item ${active ? 'active' : ''}',
              attributes: {
                'aria-label': item.label,
                'aria-current': active ? 'page' : 'false',
              },
              children: [
                span(classes: 'nav-icon', [.text(item.icon)]),
                span([.text(item.label)]),
                if (item.label == 'Market Insights') span(classes: 'nav-badge', [.text('3')]),
              ],
            );
          }),
        ],
      ),
      div(classes: 'sidebar-bottom', [
        div(classes: 'sidebar-help', [
          div(classes: 'help-symbol', [.text('?')]),
          div(classes: 'help-copy', [
            div([.text('Need help?')]),
            div(classes: 'muted small', [.text('Explore the user guide')]),
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
    ]);
  }
}
