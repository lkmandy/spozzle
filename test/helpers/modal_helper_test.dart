// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/helpers/helpers.dart';
import 'package:spozzle/theme/theme.dart';

void main() {
  group('showAppDialog', () {
    testWidgets('renders AppDialog with child', (WidgetTester tester) async {
      const Key key = Key('__child__');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) => TextButton(
              onPressed: () => showAppDialog<void>(
                context: context,
                child: SizedBox(
                  key: key,
                ),
              ),
              child: const Text('open app modal'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open app modal'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppDialog),
          matching: find.byKey(key),
        ),
        findsOneWidget,
      );
    });
  });
}
