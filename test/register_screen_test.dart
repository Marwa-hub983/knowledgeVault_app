import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_vault_app/features/auth/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renders all UI elements without question mark UI',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // Verify question mark UI is NOT present
    expect(find.text('?'), findsNothing);

    // Verify header title, subtitle & badge
    expect(find.text('Create your Vault'), findsOneWidget);
    expect(
      find.text('Start chatting with your personal\ndocuments with zero data leaks'),
      findsOneWidget,
    );
    expect(find.text('ZERO-KNOWLEDGE ARCHITECTURE'), findsOneWidget);

    // Verify input field labels
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);

    // Verify password requirement info
    expect(find.text('Must be at least 8 characters'), findsOneWidget);

    // Verify buttons and interactive elements
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('OR'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    // Verify login prompt
    expect(find.text('Already have an account? '), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    // Verify password visibility toggle
    expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('RegisterScreen validates inputs properly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // Tap Create Account with empty fields
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // Verify error snackbar appears
    expect(find.text('Please enter your full name'), findsOneWidget);
  });

  testWidgets('RegisterScreen renders without overflow on compact screen (360x640)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.text('Create your Vault'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
