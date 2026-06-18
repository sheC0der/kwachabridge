import 'package:flutter_test/flutter_test.dart';
import 'package:kwachabridge/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KwachaBridgeApp());
    await tester.pump();
  });
}
