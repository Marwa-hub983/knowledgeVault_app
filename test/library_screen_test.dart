import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_vault_app/features/documents/screens/library_screen.dart';
import 'package:knowledge_vault_app/features/main/screens/home_screen.dart';

void main() {
  testWidgets('LibraryScreen renders all UI elements from mockup',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LibraryScreen(),
      ),
    );

    // Verify top bar
    expect(find.text('Vault'), findsOneWidget);
    expect(find.text('Library'), findsWidgets); // Subtitle & main header

    // Verify header title and description
    expect(find.text('Your synced personal repository'), findsOneWidget);

    // Verify filter chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('PDF'), findsWidgets); // Filter chip & PDF emblem
    expect(find.text('DOCX'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Links'), findsOneWidget);

    // Verify sort & summary row
    expect(find.text('Sorted by Date (Recent)'), findsOneWidget);
    expect(find.textContaining('docs • 120 MB'), findsOneWidget);

    // Verify document cards
    expect(find.text('Q3 Financial Summary.pdf'), findsOneWidget);
    expect(find.text('Financials'), findsOneWidget);
    expect(find.text('Today, 9:42 AM'), findsOneWidget);
    expect(find.text('#q3'), findsOneWidget);
    expect(find.text('#finance'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);

    expect(find.text('Engineering Architecture v2.docx'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('#architecture'), findsOneWidget);
    expect(find.text('#backend'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);

    expect(find.text('Draft Notes - Oct 14.txt'), findsOneWidget);
    expect(find.text('Delete'), findsWidgets); // Revealed on swiped item
    expect(find.text('#meeting'), findsOneWidget);
    expect(find.text('#draft'), findsOneWidget);
    expect(find.text('Uploaded'), findsOneWidget);

    expect(find.text('API Reference - Auth.link'), findsOneWidget);
    expect(find.text('Oct 12'), findsOneWidget);
    expect(find.text('#api'), findsOneWidget);
    expect(find.text('#security'), findsOneWidget);

    // Verify Empty State Layout Preview section
    expect(find.text('Empty State Layout Preview'), findsOneWidget);
    expect(
      find.text('No documents yet. Add your first one'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Upload PDFs, Word docs, notes or links to start building your personal knowledge vault.',
      ),
      findsOneWidget,
    );
    expect(find.text('Add document'), findsOneWidget);

    // Verify Floating Action Button (+ Add)
    expect(find.text('Add'), findsOneWidget);

    // Verify Bottom Navigation Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Ask AI'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('LibraryScreen category filter filters document list',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LibraryScreen(),
      ),
    );

    // Tap on PDF category filter chip
    await tester.tap(find.text('PDF').first);
    await tester.pumpAndSettle();

    // PDF document is visible
    expect(find.text('Q3 Financial Summary.pdf'), findsOneWidget);
    // Other documents are filtered out
    expect(find.text('Engineering Architecture v2.docx'), findsNothing);
    expect(find.text('Draft Notes - Oct 14.txt'), findsNothing);
    expect(find.text('API Reference - Auth.link'), findsNothing);

    // Tap back to 'All'
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Engineering Architecture v2.docx'), findsOneWidget);
  });

  testWidgets('LibraryScreen view mode switch toggles between list and grid',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LibraryScreen(),
      ),
    );

    // Tap on Grid View toggle icon
    final gridIconFinder = find.byIcon(Icons.grid_view_rounded);
    expect(gridIconFinder, findsOneWidget);
    await tester.tap(gridIconFinder);
    await tester.pumpAndSettle();

    // In grid view, items are rendered inside GridView
    expect(find.byType(GridView), findsOneWidget);

    // Tap on List View toggle icon
    final listIconFinder = find.byIcon(Icons.view_agenda_outlined);
    expect(listIconFinder, findsOneWidget);
    await tester.tap(listIconFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('LibraryScreen Add Document bottom sheet opens and displays options',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LibraryScreen(),
      ),
    );

    // Tap on Floating "+ Add" button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Add to Vault'), findsOneWidget);
    expect(find.text('Upload PDF Document'), findsOneWidget);
    expect(find.text('Upload Word Document (.docx)'), findsOneWidget);
    expect(find.text('Create Text Note'), findsOneWidget);
    expect(find.text('Add Web Link'), findsOneWidget);
  });

  testWidgets('HomeScreen switches to LibraryScreen when Library tab is tapped',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Tap on Library tab in Bottom Navigation Bar
    final libraryTabFinder = find.text('Library');
    expect(libraryTabFinder, findsOneWidget);
    await tester.tap(libraryTabFinder);
    await tester.pumpAndSettle();

    // Now LibraryScreen is displayed!
    expect(find.text('Your synced personal repository'), findsOneWidget);
    expect(find.text('Empty State Layout Preview'), findsOneWidget);
    expect(find.text('Q3 Financial Summary.pdf'), findsOneWidget);

    // Tap on Home tab to return
    final homeTabFinder = find.text('Home').last;
    await tester.tap(homeTabFinder);
    await tester.pumpAndSettle();

    // Back to Home screen
    expect(find.text('Good morning, Marwa'), findsOneWidget);
  });
}
