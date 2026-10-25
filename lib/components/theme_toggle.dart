import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

@client
class ThemeToggle extends StatefulComponent {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => ThemeToggleState();
}

class ThemeToggleState extends State<ThemeToggle> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      try {
        _isDark = web.window.localStorage.getItem('trade-theme') == 'dark';
        if (_isDark) {
          web.document.body?.classList.add('dark');
          web.document.documentElement?.classList.add('dark');
        }
      } catch (_) {
        // Fallback if localStorage is restricted
      }
    }
  }

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'icon-button theme-button',
      type: ButtonType.button,
      attributes: {
        'title': _isDark ? 'Switch to light theme' : 'Switch to dark theme',
        'aria-label': _isDark ? 'Switch to light theme' : 'Switch to dark theme',
        'aria-pressed': '$_isDark',
      },
      onClick: () => setState(() {
        _isDark = !_isDark;
        final body = web.document.body;
        if (_isDark) {
          body?.classList.add('dark');
          web.document.documentElement?.classList.add('dark');
          web.window.localStorage.setItem('trade-theme', 'dark');
        } else {
          body?.classList.remove('dark');
          web.document.documentElement?.classList.remove('dark');
          web.window.localStorage.setItem('trade-theme', 'light');
        }
      }),
      [
        span([.text(_isDark ? '☀' : '☾')]),
      ],
    );
  }
}
