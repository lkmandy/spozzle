// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppDialog', () {
    testWidgets(
        'renders child in Dialog '
        'on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      const Key key = Key('__child__');

      await tester.pumpApp(
        AppDialog(
          child: SizedBox(key: key),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byKey(key),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders child in Dialog '
        'on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      const Key key = Key('__child__');

      await tester.pumpApp(
        AppDialog(
          child: SizedBox(key: key),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byKey(key),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders child in full screen SizedBox '
        'on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      const Key key = Key('__child__');

      await tester.pumpApp(
        AppDialog(
          child: SizedBox(key: key),
        ),
      );

      expect(
        find.descendant(
          of: find.byWidgetPredicate(
            (Widget widget) =>
                widget is SizedBox &&
                widget.width == double.infinity &&
                widget.height == double.infinity,
          ),
          matching: find.byKey(key),
        ),
        findsOneWidget,
      );
    });
  });
}
