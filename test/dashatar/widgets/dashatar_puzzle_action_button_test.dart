// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarPuzzleActionButton', () {
    late DashatarPuzzleBloc dashatarPuzzleBloc;
    late DashatarPuzzleState dashatarPuzzleState;
    late DashatarThemeBloc dashatarThemeBloc;
    late DashatarTheme dashatarTheme;
    late ThemeBloc themeBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      dashatarPuzzleBloc = MockDashatarPuzzleBloc();
      dashatarPuzzleState = MockDashatarPuzzleState();

      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.notStarted);

      whenListen(
        dashatarPuzzleBloc,
        Stream.value(dashatarPuzzleState),
        initialState: dashatarPuzzleState,
      );

      dashatarThemeBloc = MockDashatarThemeBloc();
      dashatarTheme = MockDashatarTheme();
      final DashatarThemeState dashatarThemeState = DashatarThemeState(
        themes: <DashatarTheme>[dashatarTheme],
        theme: dashatarTheme,
      );

      when(() => dashatarTheme.defaultColor).thenReturn(Colors.black);
      when(() => dashatarThemeBloc.state).thenReturn(dashatarThemeState);

      final MockPuzzleTheme theme = MockPuzzleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);
      themeBloc = MockThemeBloc();

      when(() => theme.buttonColor).thenReturn(Colors.black);
      when(() => themeBloc.state).thenReturn(themeState);

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets(
        'adds TimerReset to TimerBloc '
        'when tapped', (WidgetTester tester) async {
      final MockTimerBloc timerBloc = MockTimerBloc();

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(DashatarPuzzleActionButton));

      verify(() => timerBloc.add(TimerReset())).called(1);
    });

    testWidgets(
        'adds DashatarCountdownReset to DashatarPuzzleBloc '
        'with secondsToBegin equal to 5 '
        'when tapped and '
        'DashatarPuzzleStatus is started', (WidgetTester tester) async {
      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.started);

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(DashatarPuzzleActionButton));

      verify(
        () => dashatarPuzzleBloc.add(DashatarCountdownReset(secondsToBegin: 5)),
      ).called(1);
    });

    testWidgets(
        'adds DashatarCountdownReset to DashatarPuzzleBloc '
        'with secondsToBegin equal to 3 '
        'when tapped and '
        'DashatarPuzzleStatus is notStarted', (WidgetTester tester) async {
      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.notStarted);

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(DashatarPuzzleActionButton));

      verify(
        () => dashatarPuzzleBloc.add(DashatarCountdownReset(secondsToBegin: 3)),
      ).called(1);
    });

    testWidgets(
        'adds PuzzleInitialized to PuzzleBloc '
        'when tapped and '
        'DashatarPuzzleStatus is started', (WidgetTester tester) async {
      final MockPuzzleBloc puzzleBloc = MockPuzzleBloc();

      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.started);

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        puzzleBloc: puzzleBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(DashatarPuzzleActionButton));

      verify(
        () => puzzleBloc.add(PuzzleInitialized(shufflePuzzle: false)),
      ).called(1);
    });

    testWidgets(
        'plays the click sound '
        'when tapped and '
        'DashatarPuzzleStatus is not loading', (WidgetTester tester) async {
      final MockAudioPlayer audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.stop).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});

      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.notStarted);

      await tester.pumpApp(
        DashatarPuzzleActionButton(
          audioPlayer: () => audioPlayer,
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(DashatarPuzzleActionButton));

      verify(() => audioPlayer.setAsset('assets/audio/click.mp3')).called(1);
      verify(audioPlayer.play).called(1);
    });

    testWidgets(
        'renders disabled PuzzleButton '
        'when DashatarPuzzleStatus is loading', (WidgetTester tester) async {
      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.loading);

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is PuzzleButton && widget.onPressed == null,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PuzzleButton '
        'using DashatarTheme.defaultColor as text color '
        'when DashatarPuzzleStatus is loading', (WidgetTester tester) async {
      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.loading);

      const MaterialColor defaultColor = Colors.orange;
      when(() => dashatarTheme.defaultColor).thenReturn(defaultColor);

      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is PuzzleButton && widget.textColor == defaultColor,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders Tooltip', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byType(Tooltip),
        findsOneWidget,
      );
    });

    testWidgets('renders AudioControlListener', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarPuzzleActionButton(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(AudioControlListener), findsOneWidget);
    });
  });
}
