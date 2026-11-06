import 'package:flutter_test/flutter_test.dart';

import 'package:germ_smasher/main.dart';

void main() {
  testWidgets('app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const GermSmasherApp());
    await tester.pump();
    expect(find.byType(GermSmasherApp), findsOneWidget);
  });
}
