import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  testWidgets('app smoke', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SizedBox.shrink()),
    );
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
