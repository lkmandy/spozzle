// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PuzzleTitle', () {
    late ThemeBloc themeBloc;
    late PuzzleTheme theme;

    setUp(() {
      themeBloc = MockThemeBloc();
      theme = MockPuzzleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);

      when(() => theme.titleColor).thenReturn(Colors.black);
      when(() => themeBloc.state).thenReturn(themeState);
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        PuzzleTitle(title: 'Title'),
        themeBloc: themeBloc,
      );

      expect(
        find.text('Title'),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        PuzzleTitle(title: 'Title'),
        themeBloc: themeBloc,
      );

      expect(
        find.text('Title'),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        PuzzleTitle(title: 'Title'),
        themeBloc: themeBloc,
      );

      expect(
        find.text('Title'),
        findsOneWidget,
      );
    });

    testWidgets('renders text in the given color', (WidgetTester tester) async {
      const MaterialColor color = Colors.purple;

      await tester.pumpApp(
        PuzzleTitle(
          title: 'Title',
          color: color,
        ),
        themeBloc: themeBloc,
      );

      final AnimatedDefaultTextStyle textStyle = tester.firstWidget<AnimatedDefaultTextStyle>(
        find.byType(AnimatedDefaultTextStyle),
      );

      expect(textStyle.style.color, equals(color));
    });

    testWidgets(
        'renders text '
        'using PuzzleTheme.titleColor as text color '
        'if not provided', (WidgetTester tester) async {
      const MaterialColor titleColor = Colors.green;
      when(() => theme.titleColor).thenReturn(titleColor);

      await tester.pumpApp(
        PuzzleTitle(title: 'Title'),
        themeBloc: themeBloc,
      );

      final AnimatedDefaultTextStyle textStyle = tester.firstWidget<AnimatedDefaultTextStyle>(
        find.byType(AnimatedDefaultTextStyle),
      );

      expect(textStyle.style.color, equals(titleColor));
    });
  });
}
