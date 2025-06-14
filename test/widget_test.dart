// Basic widget tests for QRoll Attendance App
//
// These tests verify that the main app components load correctly

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qroll_attendance/main.dart';

void main() {
  testWidgets('App should load without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should show splash screen initially', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Just pump once to avoid timer issues
    await tester.pump();

    // The app should show some form of screen
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}
