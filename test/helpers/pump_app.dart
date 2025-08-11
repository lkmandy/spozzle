// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/arb/app_localizations.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeBloc? themeBloc,
    DashatarThemeBloc? dashatarThemeBloc,
    DashatarPuzzleBloc? dashatarPuzzleBloc,
    PuzzleBloc? puzzleBloc,
    TimerBloc? timerBloc,
    AudioControlBloc? audioControlBloc,
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider.value(
            value: themeBloc ?? MockThemeBloc(),
          ),
          BlocProvider.value(
            value: dashatarThemeBloc ?? MockDashatarThemeBloc(),
          ),
          BlocProvider.value(
            value: dashatarPuzzleBloc ?? MockDashatarPuzzleBloc(),
          ),
          BlocProvider.value(
            value: puzzleBloc ?? MockPuzzleBloc(),
          ),
          BlocProvider.value(
            value: timerBloc ?? MockTimerBloc(),
          ),
          BlocProvider.value(
            value: audioControlBloc ?? MockAudioControlBloc(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
