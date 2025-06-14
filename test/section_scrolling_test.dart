import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qroll_attendance/screens/section_attendance_report_screen.dart';
import 'package:qroll_attendance/models/course.dart';

void main() {
  group('Section Attendance Report Scrolling Tests', () {
    late Course testCourse;

    setUp(() {
      testCourse = const Course(id: '1', name: 'Test Course', code: 'TEST101');
    });

    testWidgets('Should display all 20 sections in scrollable list', (
      WidgetTester tester,
    ) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(home: SectionAttendanceReportScreen(course: testCourse)),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Check if loading indicator appears first
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load (simulate API response)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find the ListView
      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      // Get the ListView widget
      final ListView listView = tester.widget(listViewFinder);

      // Print ListView properties for debugging
      debugPrint('ListView found: ${listView.runtimeType}');
      debugPrint('ListView physics: ${listView.physics}');
      debugPrint('ListView shrinkWrap: ${listView.shrinkWrap}');
      debugPrint('ListView padding: ${listView.padding}');

      // Check if we can find section cards
      final sectionCardFinder = find.byType(Container);
      debugPrint(
        'Found ${sectionCardFinder.evaluate().length} Container widgets',
      );

      // Try to scroll to the bottom
      await tester.scrollUntilVisible(
        find.text('20'), // Looking for section number 20
        500.0,
        scrollable: listViewFinder,
      );

      // Check if section 20 is visible
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('Should be able to scroll through all sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: SectionAttendanceReportScreen(course: testCourse)),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find the scrollable widget
      final scrollableFinder = find.byType(Scrollable);
      expect(scrollableFinder, findsOneWidget);

      // Get initial scroll position
      final ScrollableState scrollableState = tester.state(scrollableFinder);
      final double initialPosition = scrollableState.position.pixels;
      debugPrint('Initial scroll position: $initialPosition');

      // Scroll down multiple times to reach the end
      for (int i = 0; i < 10; i++) {
        await tester.drag(scrollableFinder, const Offset(0, -200));
        await tester.pumpAndSettle();

        final double currentPosition = scrollableState.position.pixels;
        debugPrint('Scroll step $i: position = $currentPosition');

        // Check if we've reached the maximum scroll extent
        if (currentPosition >= scrollableState.position.maxScrollExtent) {
          debugPrint(
            'Reached maximum scroll extent: ${scrollableState.position.maxScrollExtent}',
          );
          break;
        }
      }

      // Check final position
      final double finalPosition = scrollableState.position.pixels;
      debugPrint('Final scroll position: $finalPosition');
      debugPrint(
        'Max scroll extent: ${scrollableState.position.maxScrollExtent}',
      );

      // Verify we can scroll significantly
      expect(finalPosition, greaterThan(initialPosition));
    });

    testWidgets('Test ListView builder with mock data', (
      WidgetTester tester,
    ) async {
      // Create a simple test widget with known data
      final testWidget = MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 8),
                child: Card(child: Center(child: Text('Section ${index + 1}'))),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Check if first section is visible
      expect(find.text('Section 1'), findsOneWidget);

      // Scroll to find section 20
      await tester.scrollUntilVisible(find.text('Section 20'), 500.0);

      // Verify section 20 is now visible
      expect(find.text('Section 20'), findsOneWidget);
      debugPrint('Successfully scrolled to Section 20 in test widget');
    });

    testWidgets('Check screen dimensions and available space', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: SectionAttendanceReportScreen(course: testCourse)),
      );

      await tester.pumpAndSettle();

      // Get screen size
      final Size screenSize =
          tester.view.physicalSize / tester.view.devicePixelRatio;
      debugPrint('Screen size: ${screenSize.width} x ${screenSize.height}');

      // Find the main scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      // Get scaffold size
      final RenderBox scaffoldBox = tester.renderObject(scaffoldFinder);
      debugPrint(
        'Scaffold size: ${scaffoldBox.size.width} x ${scaffoldBox.size.height}',
      );

      // Find the app bar
      final appBarFinder = find.byType(AppBar);
      if (appBarFinder.evaluate().isNotEmpty) {
        final RenderBox appBarBox = tester.renderObject(appBarFinder);
        debugPrint('AppBar height: ${appBarBox.size.height}');
      }

      // Calculate available space for content
      final double availableHeight =
          scaffoldBox.size.height -
          (appBarFinder.evaluate().isNotEmpty ? 80 : 0);
      debugPrint('Available height for content: $availableHeight');

      // Estimate how many sections can fit on screen
      const double sectionHeight = 80; // Approximate height of each section
      final int sectionsPerScreen = (availableHeight / sectionHeight).floor();
      debugPrint('Estimated sections per screen: $sectionsPerScreen');
      debugPrint('Total sections needed: 20');
      debugPrint('Scrolling required: ${20 > sectionsPerScreen}');
    });
  });

  group('Mock Data Tests', () {
    testWidgets('Test with simulated API response data', (
      WidgetTester tester,
    ) async {
      // Create a test widget that simulates the actual section list
      final List<Map<String, dynamic>> mockSections = List.generate(
        20,
        (index) => {
          'id': index + 1,
          'date': '2024-01-${(index + 1).toString().padLeft(2, '0')}',
          'status':
              index % 3 == 0 ? 'present' : (index % 3 == 1 ? 'absent' : 'late'),
          'created_at':
              '2024-01-${(index + 1).toString().padLeft(2, '0')}T10:00:00Z',
        },
      );

      debugPrint('Created ${mockSections.length} mock sections');

      final testWidget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test Sections')),
          body: Column(
            children: [
              // Header similar to the actual app
              Container(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Expanded(flex: 2, child: Text('SECTION NUMBER')),
                    Expanded(flex: 2, child: Text('DATE')),
                    Expanded(flex: 1, child: Text('STATUS')),
                  ],
                ),
              ),
              // List similar to the actual app
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: mockSections.length,
                  itemBuilder: (context, index) {
                    final section = mockSections[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(width: 50, child: Text('${index + 1}')),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 80),
                              child: Text(section['date']),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(section['status'].toUpperCase()),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Check if first section is visible
      expect(find.text('1'), findsOneWidget);
      debugPrint('Section 1 found');

      // Try to scroll to section 20
      final scrollableFinder = find.byType(Scrollable);
      final ScrollableState scrollableState = tester.state(scrollableFinder);

      debugPrint('Starting scroll test...');
      debugPrint(
        'Initial max scroll extent: ${scrollableState.position.maxScrollExtent}',
      );

      // Scroll to the bottom
      await tester.scrollUntilVisible(
        find.text('20'),
        500.0,
        scrollable: scrollableFinder,
      );

      // Check if section 20 is now visible
      expect(find.text('20'), findsOneWidget);
      debugPrint('Successfully found section 20!');

      // Check final scroll position
      final double finalPosition = scrollableState.position.pixels;
      debugPrint('Final scroll position: $finalPosition');
      debugPrint(
        'Max scroll extent: ${scrollableState.position.maxScrollExtent}',
      );
    });
  });
}
