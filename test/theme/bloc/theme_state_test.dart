// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeState', () {
    test('supports value comparisons', () {
      final List<MockPuzzleTheme> themes = <MockPuzzleTheme>[MockPuzzleTheme(), MockPuzzleTheme()];

      expect(
        ThemeState(
          themes: themes,
          theme: themes[0],
        ),
        equals(
          ThemeState(
            themes: themes,
            theme: themes[0],
          ),
        ),
      );
    });

    test('default theme is SimpleTheme', () {
      expect(
        ThemeState(themes: const <PuzzleTheme>[SimpleTheme()]).theme,
        equals(SimpleTheme()),
      );
    });

    group('copyWith', () {
      test('updates themes', () {
        final List<PuzzleTheme> themesA = <PuzzleTheme>[SimpleTheme(), LittoralDashatarTheme()];
        final List<PuzzleTheme> themesB = <PuzzleTheme>[SimpleTheme(), NorthDashatarTheme()];

        expect(
          ThemeState(
            themes: themesA,
            theme: SimpleTheme(),
          ).copyWith(themes: themesB),
          equals(
            ThemeState(
              themes: themesB,
              theme: SimpleTheme(),
            ),
          ),
        );
      });

      test('updates theme', () {
        final List<PuzzleTheme> themes = <PuzzleTheme>[SimpleTheme(), NorthDashatarTheme()];
        final SimpleTheme themeA = SimpleTheme();
        final NorthDashatarTheme themeB = NorthDashatarTheme();

        expect(
          ThemeState(
            themes: themes,
            theme: themeA,
          ).copyWith(theme: themeB),
          equals(
            ThemeState(
              themes: themes,
              theme: themeB,
            ),
          ),
        );
      });
    });
  });
}
