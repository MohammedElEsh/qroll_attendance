import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple 20 item scroll test', (WidgetTester tester) async {
    // Create a simple app with 20 items
    final app = MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Scroll Test'), toolbarHeight: 80),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'SECTION\nNUMBER',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'DATE',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'STATUS',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              // Content area
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: false,
                  cacheExtent: 1000,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80),
                                child: Text(
                                  '2024-01-${(index + 1).toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              constraints: const BoxConstraints(maxWidth: 120),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'PRESENT',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Build the app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    print('=== SCROLL TEST STARTED ===');

    // Check if first item is visible
    expect(find.text('1'), findsOneWidget);
    print('✓ Section 1 found');

    // Get scrollable widget
    final scrollableFinder = find.byType(Scrollable);
    expect(scrollableFinder, findsOneWidget);

    final ScrollableState scrollableState = tester.state(scrollableFinder);
    print('Initial scroll position: ${scrollableState.position.pixels}');
    print('Max scroll extent: ${scrollableState.position.maxScrollExtent}');

    // Try to find section 17 (where it stops)
    try {
      await tester.scrollUntilVisible(
        find.text('17'),
        500.0,
        scrollable: scrollableFinder,
      );
      print('✓ Section 17 found');
    } catch (e) {
      print('✗ Section 17 NOT found: $e');
    }

    // Try to find section 18
    try {
      await tester.scrollUntilVisible(
        find.text('18'),
        500.0,
        scrollable: scrollableFinder,
      );
      print('✓ Section 18 found');
    } catch (e) {
      print('✗ Section 18 NOT found: $e');
    }

    // Try to find section 19
    try {
      await tester.scrollUntilVisible(
        find.text('19'),
        500.0,
        scrollable: scrollableFinder,
      );
      print('✓ Section 19 found');
    } catch (e) {
      print('✗ Section 19 NOT found: $e');
    }

    // Try to find section 20
    try {
      await tester.scrollUntilVisible(
        find.text('20'),
        500.0,
        scrollable: scrollableFinder,
      );
      print('✓ Section 20 found');
    } catch (e) {
      print('✗ Section 20 NOT found: $e');
    }

    // Manual scroll to bottom
    print('\n=== MANUAL SCROLL TEST ===');
    await tester.drag(scrollableFinder, const Offset(0, -2000));
    await tester.pumpAndSettle();

    final double finalPosition = scrollableState.position.pixels;
    print('Final scroll position after drag: $finalPosition');
    print('Max scroll extent: ${scrollableState.position.maxScrollExtent}');

    // Check what's visible now
    for (int i = 15; i <= 20; i++) {
      final finder = find.text('$i');
      if (finder.evaluate().isNotEmpty) {
        print('✓ Section $i is visible');
      } else {
        print('✗ Section $i is NOT visible');
      }
    }

    print('=== SCROLL TEST COMPLETED ===');
  });
}
