import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class FeaturePlaceholderPage extends StatelessComponent {
  const FeaturePlaceholderPage({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Component build(BuildContext context) {
    return div(classes: 'feature-placeholder panel', [
      div(classes: 'eyebrow', [.text('TRADE INTELLIGENCE')]),
      h1([.text(title)]),
      p(classes: 'page-description', [.text(description)]),
      p(classes: 'muted small', [.text('This section is ready for its feature module.')]),
    ]);
  }
}
