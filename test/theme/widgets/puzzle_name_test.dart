// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PuzzleName', () {
    late ThemeBloc themeBloc;
    late PuzzleTheme theme;

    const String themeName = 'Name';

    setUp(() {
      themeBloc = MockThemeBloc();
      theme = MockPuzzleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);

      when(() => theme.name).thenReturn(themeName);
      when(() => theme.nameColor).thenReturn(Colors.black);
      when(() => themeBloc.state).thenReturn(themeState);
    });

    testWidgets(
        'renders theme name '
        'on a medium display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        PuzzleName(),
        themeBloc: themeBloc,
      );

      expect(find.text(themeName), findsOneWidget);
    });

    testWidgets(
        'renders an empty widget '
        'on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        PuzzleName(),
        themeBloc: themeBloc,
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text(themeName), findsNothing);
    });

    testWidgets(
        'renders an empty widget '
        'on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        PuzzleName(),
        themeBloc: themeBloc,
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text(themeName), findsNothing);
    });

    testWidgets('renders text in the given color', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      const MaterialColor color = Colors.purple;

      await tester.pumpApp(
        PuzzleName(color: color),
        themeBloc: themeBloc,
      );

      final AnimatedDefaultTextStyle textStyle = tester.firstWidget<AnimatedDefaultTextStyle>(
        find.byType(AnimatedDefaultTextStyle),
      );

      expect(textStyle.style.color, equals(color));
    });

    testWidgets(
        'renders text '
        'using PuzzleTheme.nameColor as text color '
        'if not provided', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      const MaterialColor nameColor = Colors.green;
      when(() => theme.nameColor).thenReturn(nameColor);

      await tester.pumpApp(
        PuzzleName(),
        themeBloc: themeBloc,
      );

      final AnimatedDefaultTextStyle textStyle = tester.firstWidget<AnimatedDefaultTextStyle>(
        find.byType(AnimatedDefaultTextStyle),
      );

      expect(textStyle.style.color, equals(nameColor));
    });
  });
}
