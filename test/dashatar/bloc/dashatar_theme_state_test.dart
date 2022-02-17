// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarThemeState', () {
    test('supports value comparisons', () {
      final theme = MockDashatarTheme();
      final themes = [theme];

      expect(
        DashatarThemeState(themes: themes, theme: theme),
        equals(DashatarThemeState(themes: themes, theme: theme)),
      );

      expect(
        DashatarThemeState(themes: themes, theme: theme),
        isNot(DashatarThemeState(themes: themes, theme: MockDashatarTheme())),
      );
    });

    test('default theme is GreenDashatarTheme', () {
      expect(
        DashatarThemeState(themes: [MockDashatarTheme()]).theme,
        equals(LittoralDashatarTheme()),
      );
    });

    group('copyWith', () {
      test('updates themes', () {
        final themesA = [LittoralDashatarTheme()];
        final themesB = [WestDashatarTheme()];
        expect(
          DashatarThemeState(
            themes: themesA,
          ).copyWith(themes: themesB),
          equals(
            DashatarThemeState(
              themes: themesB,
            ),
          ),
        );
      });

      test('updates theme', () {
        final themes = [LittoralDashatarTheme(), WestDashatarTheme()];
        final themeA = LittoralDashatarTheme();
        final themeB = WestDashatarTheme();

        expect(
          DashatarThemeState(
            themes: themes,
            theme: themeA,
          ).copyWith(theme: themeB),
          equals(
            DashatarThemeState(
              themes: themes,
              theme: themeB,
            ),
          ),
        );
      });
    });
  });
}
