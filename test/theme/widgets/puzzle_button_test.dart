// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PuzzleButton', () {
    late PuzzleTheme theme;
    late ThemeBloc themeBloc;

    setUp(() {
      theme = MockPuzzleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);
      themeBloc = MockThemeBloc();

      when(() => theme.buttonColor).thenReturn(Colors.black);
      when(() => themeBloc.state).thenReturn(themeState);
    });

    testWidgets('renders AnimatedTextButton', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleButton(
          onPressed: () {},
          child: SizedBox(),
        ),
        themeBloc: themeBloc,
      );

      expect(find.byType(AnimatedTextButton), findsOneWidget);
    });

    testWidgets('renders child', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleButton(
          onPressed: () {},
          child: SizedBox(
            key: Key('__text__'),
          ),
        ),
        themeBloc: themeBloc,
      );

      expect(find.byKey(Key('__text__')), findsOneWidget);
    });

    testWidgets(
        'calls onPressed '
        'when tapped', (WidgetTester tester) async {
      bool onPressedCalled = false;

      await tester.pumpApp(
        PuzzleButton(
          onPressed: () => onPressedCalled = true,
          child: SizedBox(),
        ),
        themeBloc: themeBloc,
      );

      await tester.tap(find.byType(PuzzleButton));

      expect(onPressedCalled, isTrue);
    });

    group('backgroundColor', () {
      testWidgets('defaults to PuzzleTheme.buttonColor', (WidgetTester tester) async {
        const MaterialColor themeBackgroundColor = Colors.orange;
        when(() => theme.buttonColor).thenReturn(themeBackgroundColor);

        await tester.pumpApp(
          PuzzleButton(
            onPressed: () {},
            child: SizedBox(),
          ),
          themeBloc: themeBloc,
        );

        expect(
          tester.firstWidget<Material>(find.byType(Material)).color,
          equals(themeBackgroundColor),
        );
      });

      testWidgets('can be overriden with a property', (WidgetTester tester) async {
        const MaterialColor backgroundColor = Colors.purple;
        const MaterialColor themeBackgroundColor = Colors.orange;
        when(() => theme.buttonColor).thenReturn(themeBackgroundColor);

        await tester.pumpApp(
          PuzzleButton(
            onPressed: () {},
            backgroundColor: backgroundColor,
            child: SizedBox(),
          ),
          themeBloc: themeBloc,
        );

        expect(
          tester.firstWidget<Material>(find.byType(Material)).color,
          equals(backgroundColor),
        );
      });
    });

    group('textColor', () {
      testWidgets('defaults to PuzzleColors.white', (WidgetTester tester) async {
        await tester.pumpApp(
          PuzzleButton(
            onPressed: () {},
            child: SizedBox(),
          ),
          themeBloc: themeBloc,
        );

        expect(
          tester.firstWidget<Material>(find.byType(Material)).textStyle?.color,
          equals(PuzzleColors.white),
        );
      });

      testWidgets('can be overriden with a property', (WidgetTester tester) async {
        const MaterialColor textColor = Colors.orange;

        await tester.pumpApp(
          PuzzleButton(
            onPressed: () {},
            textColor: textColor,
            child: SizedBox(),
          ),
          themeBloc: themeBloc,
        );

        expect(
          tester.firstWidget<Material>(find.byType(Material)).textStyle?.color,
          equals(textColor),
        );
      });
    });
  });
}
