import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_vault_app/features/search&chat/screens/ask_ai_screen.dart';

void main() {
  testWidgets('AskAiScreen renders all UI elements from design screenshot',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: AskAiScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Top Bar
    expect(find.text('Vault'), findsOneWidget);
    expect(find.text('Ask AI'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    // Verify Scope pill chip
    expect(find.text('All documents'), findsOneWidget);

    // Verify Header Banner
    expect(find.text('Ask anything about your documents'), findsOneWidget);
    expect(
      find.text(
        'Responses are strictly grounded in your indexed files with source citations and verified chunk anchors.',
      ),
      findsOneWidget,
    );

    // Verify 4 Suggested prompt pills
    expect(
      find.text('What were the key takeaways from Q3?'),
      findsOneWidget,
    );
    expect(
      find.text('Explain the Riverpod state architecture'),
      findsOneWidget,
    );
    expect(
      find.text('Summarize AES-256 key derivation'),
      findsOneWidget,
    );
    expect(
      find.text('Compare indexing latency across chunks'),
      findsOneWidget,
    );

    // Verify User Message 1
    expect(
      find.text(
        'How is Riverpod 2.0 evaluated compared to BLoC in our engineering review?',
      ),
      findsOneWidget,
    );

    // Verify AI Response 1
    expect(find.text('Vault AI'), findsOneWidget);
    expect(find.text('Grounded in 2 sources'), findsOneWidget);
    expect(find.text('VERIFIED SOURCES'), findsOneWidget);
    expect(find.text('98% match'), findsOneWidget);
    expect(find.text('92% match'), findsOneWidget);
    expect(find.text('184 tokens • 42ms'), findsOneWidget);

    // Verify User Message 2
    expect(
      find.text('What is our Q4 marketing budget allocation for paid search?'),
      findsOneWidget,
    );

    // Verify Verification Notice
    expect(find.text('Vault AI • Verification Notice'), findsOneWidget);
    expect(find.text('Upload Q4 Marketing Plan'), findsOneWidget);
    expect(find.text('Search wider web'), findsOneWidget);

    // Verify Synthesizing Card
    expect(find.text('Vault AI is synthesizing...'), findsOneWidget);
    expect(find.text('Matching 5 document embeddings'), findsOneWidget);

    // Verify Docked Input Bar
    expect(
      find.text('Searching in All documents [24 files]'),
      findsOneWidget,
    );
    expect(find.text('Change'), findsOneWidget);
    expect(
      find.text('Ask a question about your documents...'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.attach_file_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);

    // Verify Bottom Navigation Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets(
      'AskAiScreen opens citation chunk sheet when tapping a verified source',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: AskAiScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap on the first source card
    final sourceFinder = find.text('Flutter Interview Note...');
    await tester.tap(sourceFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Citation chunk sheet should appear
    expect(find.text('VERIFIED CITATION CHUNK'), findsOneWidget);
    expect(find.text('Open Full Document'), findsOneWidget);
  });

  testWidgets('AskAiScreen opens scope picker when tapping Change',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: AskAiScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap on "Change"
    await tester.tap(find.text('Change'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Scope sheet should show
    expect(find.text('Select Knowledge Scope'), findsOneWidget);
    expect(find.text('Core Engineering'), findsOneWidget);
    expect(find.text('Financials & Audits'), findsOneWidget);
  });

  testWidgets('AskAiScreen allows asking a suggested question',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: AskAiScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap on suggested question "What were the key takeaways from Q3?"
    await tester.tap(find.text('What were the key takeaways from Q3?'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Synthesizing should appear
    expect(find.text('Vault AI is synthesizing...'), findsWidgets);

    // Fast forward animation
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 200));

    // Grounded answer should be present
    expect(
      find.textContaining('Key highlights synthesized', findRichText: true),
      findsOneWidget,
    );
  });
}
