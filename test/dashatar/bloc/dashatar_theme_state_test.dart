// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarThemeState', () {
    test('supports value comparisons', () {
      final MockDashatarTheme theme = MockDashatarTheme();
      final List<MockDashatarTheme> themes = <MockDashatarTheme>[theme];

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
        DashatarThemeState(themes: <DashatarTheme>[MockDashatarTheme()]).theme,
        equals(LittoralDashatarTheme()),
      );
    });

    group('copyWith', () {
      test('updates themes', () {
        final List<LittoralDashatarTheme> themesA = <LittoralDashatarTheme>[LittoralDashatarTheme()];
        final List<WestDashatarTheme> themesB = <WestDashatarTheme>[WestDashatarTheme()];
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
        final List<DashatarTheme> themes = <DashatarTheme>[LittoralDashatarTheme(), WestDashatarTheme()];
        final LittoralDashatarTheme themeA = LittoralDashatarTheme();
        final WestDashatarTheme themeB = WestDashatarTheme();

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
