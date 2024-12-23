// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppFlutterLogo', () {
    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(AppFlutterLogo());

      expect(
        find.byType(Image),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(AppFlutterLogo());

      expect(
        find.byType(Image),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(AppFlutterLogo());

      expect(
        find.byType(Image),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders colored Image '
        'when isColored is true', (WidgetTester tester) async {
      await tester.pumpApp(
        AppFlutterLogo(
          isColored: true,
          height: 18,
        ),
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/logo_spozzle_color.png',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders white Image '
        'when isColored is false', (WidgetTester tester) async {
      await tester.pumpApp(
        AppFlutterLogo(
          isColored: false,
        ),
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/logo_spozzle_white.png',
        ),
        findsOneWidget,
      );
    });
  });
}
