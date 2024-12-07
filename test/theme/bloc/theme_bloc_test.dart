// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeBloc', () {
    test('initial state is ThemeState', () {
      final List<MockPuzzleTheme> themes = <MockPuzzleTheme>[MockPuzzleTheme()];
      expect(
        ThemeBloc(initialThemes: themes).state,
        equals(ThemeState(themes: themes)),
      );
    });

    group('ThemeChanged', () {
      late PuzzleTheme theme;
      late List<PuzzleTheme> themes;

      blocTest<ThemeBloc, ThemeState>(
        'emits new theme',
        setUp: () {
          theme = MockPuzzleTheme();
          themes = <PuzzleTheme>[MockPuzzleTheme(), theme];
        },
        build: () => ThemeBloc(initialThemes: themes),
        act: (ThemeBloc bloc) => bloc.add(ThemeChanged(themeIndex: 1)),
        expect: () => <ThemeState>[
          ThemeState(themes: themes, theme: theme),
        ],
      );
    });

    group('ThemeUpdated', () {
      late List<PuzzleTheme> themes;

      blocTest<ThemeBloc, ThemeState>(
        'replaces the theme identified by name '
        'in the list of themes',
        setUp: () {
          themes = <PuzzleTheme>[
            /// Name: 'Simple'
            SimpleTheme(),

            ///  Name: 'Dashatar'
            LittoralDashatarTheme(),
          ];
        },
        build: () => ThemeBloc(initialThemes: themes),
        act: (ThemeBloc bloc) => bloc.add(ThemeUpdated(theme: NorthDashatarTheme())),
        expect: () => <ThemeState>[
          ThemeState(
            themes: const <PuzzleTheme>[
              /// Name: 'Simple'
              SimpleTheme(),

              ///  Name: 'Dashatar'
              NorthDashatarTheme(),
            ],
            theme: NorthDashatarTheme(),
          ),
        ],
      );
    });
  });
}
