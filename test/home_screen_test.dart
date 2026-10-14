import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_vault_app/features/main/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders all UI sections from screenshot',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify top bar
    expect(find.text('Vault'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);

    // Verify greeting and user status
    expect(find.text('Good morning, Marwa'), findsOneWidget);
    expect(find.text('Personal Knowledge Vault'), findsOneWidget);
    expect(find.text('24 items synced'), findsOneWidget);

    // Verify AI Search Bar
    expect(find.text('Ask your vault anything...'), findsOneWidget);

    // Verify Metrics row
    expect(find.text('24'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('+3'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('Folders'), findsOneWidget);
    expect(find.text('Tidy'), findsOneWidget);
    expect(find.text('120MB'), findsOneWidget);
    expect(find.text('of 20 GB'), findsOneWidget);
    expect(find.text('0.6%'), findsOneWidget);

    // Verify processing pipeline
    expect(find.text('2 documents processing'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Queue'), findsOneWidget);
    expect(
      find.text('Extracting text & generating vector emb...'),
      findsOneWidget,
    );
    expect(find.text('Vector pipeline #104'), findsOneWidget);
    expect(find.text('65% complete'), findsOneWidget);

    // Verify recent documents
    expect(find.text('Recent documents'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);
    expect(find.text('Q3 Financial Summary.pdf'), findsOneWidget);
    expect(find.text('Engineering Architecture.docx'), findsOneWidget);

    // Verify suggested questions
    expect(find.text('Suggested questions'), findsOneWidget);
    expect(
      find.text('"What were the key takeaways from Q3..."'),
      findsOneWidget,
    );
    expect(
      find.text('"Summarize engineering architecture..."'),
      findsOneWidget,
    );
    expect(find.text('"List action items from team sync"'), findsOneWidget);
    expect(
      find.text('"Compare indexing latency across..."'),
      findsOneWidget,
    );

    // Verify Add Document CTA button
    expect(find.text('Add Document'), findsOneWidget);

    // Verify bottom navigation bar items
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Ask AI'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('HomeScreen interactions trigger expected feedback',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Tap on Add Document button
    await tester.tap(find.text('Add Document'));
    await tester.pumpAndSettle();
    expect(find.text('Add Document action clicked'), findsOneWidget);

    // Tap on a suggested question
    final questionFinder = find.text('"List action items from team sync"');
    await tester.ensureVisible(questionFinder);
    await tester.tap(questionFinder);
    await tester.pumpAndSettle();
    expect(
      find.text('Asking: "List action items from team sync"'),
      findsOneWidget,
    );
  });
}
