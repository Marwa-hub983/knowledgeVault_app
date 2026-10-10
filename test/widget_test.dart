import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_vault_app/my_app.dart';

void main() {
  testWidgets('Onboarding screen loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('VAULT OS'), findsOneWidget);
  });
}
