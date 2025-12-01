import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_skincare_platform/main.dart' as app;
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login, view home, and open scan sample result', (tester) async {
    SharedPreferences.setMockInitialValues(
      {'onboarding_completed': true},
    );

    await app.main();
    await tester.pumpAndSettle();

    expect(find.text('Welcome back!'), findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField).at(0), 'demo@healzone.app');
    await tester.enterText(find.byType(TextFormField).at(1), 'Demo123');
    await tester.tap(find.byType(HzPrimaryButton).first);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.textContaining('Latest stories'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final router = materialApp.routerConfig as GoRouter;
    router.go('/scan/capture');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('View sample result'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('View sample result'));
    await tester.pumpAndSettle();

    expect(find.text('Latest scan result'), findsOneWidget);
  });
}
