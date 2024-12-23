// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarThemeBloc', () {
    test('initial state is correct', () {
      final List<MockDashatarTheme> themes = <MockDashatarTheme>[MockDashatarTheme()];

      expect(
        DashatarThemeBloc(themes: themes).state,
        equals(
          DashatarThemeState(themes: themes),
        ),
      );
    });

    group('DashatarThemeChanged', () {
      late DashatarTheme theme;
      late List<DashatarTheme> themes;

      blocTest<DashatarThemeBloc, DashatarThemeState>(
        'emits new theme',
        setUp: () {
          theme = MockDashatarTheme();
          themes = <DashatarTheme>[MockDashatarTheme(), theme];
        },
        build: () => DashatarThemeBloc(themes: themes),
        act: (DashatarThemeBloc bloc) => bloc.add(DashatarThemeChanged(themeIndex: 1)),
        expect: () => <DashatarThemeState>[
          DashatarThemeState(themes: themes, theme: theme),
        ],
      );
    });
  });
}
