// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elmasroof/main.dart';

void main() {
  test('Test increase expenses function', () async{

    //  today  days  punishUntil  decrease
    //    2     1         5          1
    //    4     2         5          2
    //    5     3         5          3
    //    7     4         5          2
    //    7     2         5          0
    var today = DateTime.now();
    var days = [1, 2, 3, 4, 2, 1, 2];
    var punish = [
      today.add(Duration(days: 3)),
      today.add(Duration(days: 1)),
      today,
      today.subtract(Duration(days: 2)),
      today.subtract(Duration(days: 2)),
      today,
      today.subtract(Duration(days: 1)),
    ];
    var expected = [1, 2, 3, 2, 0];
      /// print(today.compareTo(future)); // -1
      /// print(today.compareTo(past)); // 1
      /// print(today.compareTo(newDate)); // 0
      for(int i = 0; i < 5; i++) {
        if (today.compareTo(punish[i]) < 1) {
          expect(days[i], expected[i]);
        } else if (today.subtract(Duration(days: days[i])).compareTo(punish[i]) == -1) {
          expect(punish[i].difference(today).inDays + days[i], expected[i]);
        } else {
          expect(0, expected[i]);
        }
      }
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
