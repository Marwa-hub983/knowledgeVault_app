import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/auth_services.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/auth_session_service.dart';
import 'package:knowledge_vault_app/features/main/screens/home_screen.dart';
import 'package:knowledge_vault_app/my_app.dart';
import 'package:knowledge_vault_app/shared/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AuthSessionService stores and clears login session and remembers last email', () async {
    const sessionService = AuthSessionService();

    expect(await sessionService.isLoggedIn(), isFalse);
    expect(await sessionService.storedLoginFlag(), isNull);
    expect(await sessionService.getLastEmail(), isNull);

    await sessionService.saveLoginSession(
      uid: 'user-123',
      email: 'marwa@example.com',
      displayName: 'Marwa',
    );

    expect(await sessionService.isLoggedIn(), isTrue);
    expect(await sessionService.storedLoginFlag(), isTrue);
    expect(await sessionService.getLastEmail(), 'marwa@example.com');
    final info = await sessionService.getStoredUserInfo();
    expect(info.email, 'marwa@example.com');
    expect(info.displayName, 'Marwa');

    await const AuthService().signOut();

    expect(await sessionService.isLoggedIn(), isFalse);
    expect(await sessionService.storedLoginFlag(), isFalse);
    // Last email is remembered for prefilling login screen after logout
    expect(await sessionService.getLastEmail(), 'marwa@example.com');
    final clearedInfo = await sessionService.getStoredUserInfo();
    expect(clearedInfo.displayName, isNull);
  });

  test('resolveLoginOnLaunch preserves stored login until signOut', () async {
    const service = AuthService();
    const sessionService = AuthSessionService();

    // Fresh install stays logged out.
    expect(await service.resolveLoginOnLaunch(showOnboarding: true), isFalse);

    // Once logged in, subsequent launches stay logged in.
    await sessionService.saveLoginSession(
      uid: 'user-123',
      email: 'marwa@example.com',
      displayName: 'Marwa',
    );
    expect(await service.resolveLoginOnLaunch(showOnboarding: false), isTrue);

    // After explicit signOut, launches require login again.
    await service.signOut();
    expect(await service.resolveLoginOnLaunch(showOnboarding: false), isFalse);
  });

  testWidgets('Returning logged-in user opens HomeScreen directly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MyApp(
        showOnboarding: false,
        isLoggedIn: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Marwa'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);

    GoRouter.of(tester.element(find.text('Good morning, Marwa')))
        .go(onBoarding);
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Marwa'), findsOneWidget);
  });

  testWidgets('Logged-out user opens LoginScreen with remembered email',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const sessionService = AuthSessionService();
    await sessionService.saveLoginSession(
      uid: 'user-123',
      email: 'marwa@example.com',
      displayName: 'Marwa',
    );
    await const AuthService().signOut();

    await tester.pumpWidget(
      const MyApp(
        showOnboarding: false,
        isLoggedIn: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Good morning, Marwa'), findsNothing);
    expect(find.text('marwa@example.com'), findsOneWidget);
  });

  testWidgets('HomeScreen greeting dynamically updates based on logged in user name',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const sessionService = AuthSessionService();
    await sessionService.saveLoginSession(
      uid: 'user-456',
      email: 'alex.smith@example.com',
      displayName: 'Alex Smith',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify first name greeting is used
    expect(find.text('Good morning, Alex'), findsOneWidget);

    // Verify full name appears in Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Alex Smith'), findsOneWidget);
    expect(find.text('alex.smith@example.com'), findsOneWidget);
  });

  testWidgets('Logging out from Settings clears session and returns to login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const sessionService = AuthSessionService();
    await sessionService.saveLoginSession(
      uid: 'user-123',
      email: 'marwa@example.com',
      displayName: 'Marwa',
    );

    await tester.pumpWidget(
      const MyApp(
        showOnboarding: false,
        isLoggedIn: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('marwa@example.com'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(await sessionService.isLoggedIn(), isFalse);
  });
}
