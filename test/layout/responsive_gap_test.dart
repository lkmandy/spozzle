// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:spozzle/layout/layout.dart';

import '../helpers/helpers.dart';

void main() {
  group('ResponsiveGap', () {
    const double smallGap = 10.0;
    const double mediumGap = 20.0;
    const double largeGap = 30.0;

    testWidgets('renders a large gap on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Gap && widget.mainAxisExtent == largeGap,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders a medium gap on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Gap && widget.mainAxisExtent == mediumGap,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders a small gap on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Gap && widget.mainAxisExtent == smallGap,
        ),
        findsOneWidget,
      );
    });
  });
}
