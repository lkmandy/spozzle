// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeState', () {
    test('supports value comparisons', () {
      final themes = [MockPuzzleTheme(), MockPuzzleTheme()];

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
        ThemeState(themes: const [SimpleTheme()]).theme,
        equals(SimpleTheme()),
      );
    });

    group('copyWith', () {
      test('updates themes', () {
        final themesA = [SimpleTheme(), LittoralDashatarTheme()];
        final themesB = [SimpleTheme(), NorthDashatarTheme()];

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
        final themes = [SimpleTheme(), NorthDashatarTheme()];
        final themeA = SimpleTheme();
        final themeB = NorthDashatarTheme();

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
