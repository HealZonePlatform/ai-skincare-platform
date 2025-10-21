import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ai_skincare_platform/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    expect(find.text('Welcome back!'), findsOneWidget);
  });
}
