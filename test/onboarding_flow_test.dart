import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/features/auth/domain/services/onboarding_service.dart';
import 'package:knowledge_vault_app/my_app.dart';
import 'package:knowledge_vault_app/shared/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('OnboardingService defaults to false and persists completion', () async {
    const service = OnboardingService();

    expect(await service.hasSeenOnboarding(), isFalse);

    await service.markOnboardingCompleted();

    expect(await service.hasSeenOnboarding(), isTrue);
  });

  test('shouldShowOnboardingOnLaunch returns true only on first launch',
      () async {
    const service = OnboardingService();

    expect(await service.shouldShowOnboardingOnLaunch(), isTrue);
    expect(await service.hasSeenOnboarding(), isTrue);
    expect(await service.shouldShowOnboardingOnLaunch(), isFalse);
  });

  testWidgets('First install shows onboarding screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const service = OnboardingService();
    final hasSeen = await service.hasSeenOnboarding();

    await tester.pumpWidget(MyApp(showOnboarding: !hasSeen));
    await tester.pumpAndSettle();

    expect(find.text('VAULT OS'), findsOneWidget);
    expect(find.text('Keep all your knowledge in one place'), findsOneWidget);
  });

  testWidgets('Returning launch skips onboarding and opens login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({
      OnboardingService.hasSeenOnboardingKey: true,
    });
    const service = OnboardingService();
    final hasSeen = await service.hasSeenOnboarding();

    await tester.pumpWidget(MyApp(showOnboarding: !hasSeen));
    await tester.pumpAndSettle();

    expect(find.text('VAULT OS'), findsNothing);
    expect(find.text('Welcome back'), findsOneWidget);

    GoRouter.of(tester.element(find.text('Welcome back'))).go(onBoarding);
    await tester.pumpAndSettle();

    expect(find.text('VAULT OS'), findsNothing);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Tapping Skip marks onboarding complete and navigates to login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const service = OnboardingService();
    await tester.pumpWidget(const MyApp(showOnboarding: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(await service.hasSeenOnboarding(), isTrue);
  });

  testWidgets(
      'Completing all onboarding slides marks onboarding complete and navigates to login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    const service = OnboardingService();
    await tester.pumpWidget(const MyApp(showOnboarding: true));
    await tester.pumpAndSettle();

    // Advance from page 0 -> 1 -> 2 -> 3
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(await service.hasSeenOnboarding(), isTrue);
  });
}
