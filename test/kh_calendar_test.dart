import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kh_calendar/kh_calendar.dart';

void main() {
  group('KhmerCalendar Tests', () {
    testWidgets('KhmerCalendar renders without error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KhmerCalendar(),
          ),
        ),
      );

      expect(find.byType(KhmerCalendar), findsOneWidget);
    });

    testWidgets('KhmerCalendar shows current month',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KhmerCalendar(),
          ),
        ),
      );

      // Should find Khmer month names
      final monthNames = [
        'មករា',
        'កុម្ភៈ',
        'មីនា',
        'មេសា',
        'ឧសភា',
        'មិថុនា',
        'កក្កដា',
        'សីហា',
        'កញ្ញា',
        'តុលា',
        'វិច្ឆិកា',
        'ធ្នូ'
      ];

      bool foundMonth = false;
      for (String month in monthNames) {
        if (tester.any(find.textContaining(month))) {
          foundMonth = true;
          break;
        }
      }

      expect(foundMonth, isTrue);
    });
  });
}
