// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarCountdown', () {
    late DashatarPuzzleBloc dashatarPuzzleBloc;
    late DashatarThemeBloc dashatarThemeBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      dashatarPuzzleBloc = MockDashatarPuzzleBloc();
      final DashatarPuzzleState dashatarPuzzleState = DashatarPuzzleState(secondsToBegin: 3);
      whenListen(
        dashatarPuzzleBloc,
        Stream.value(dashatarPuzzleState),
        initialState: dashatarPuzzleState,
      );

      dashatarThemeBloc = MockDashatarThemeBloc();
      final List<LittoralDashatarTheme> themes = <LittoralDashatarTheme>[LittoralDashatarTheme()];
      final DashatarThemeState dashatarThemeState = DashatarThemeState(themes: themes);
      whenListen(
        dashatarThemeBloc,
        Stream.value(dashatarThemeState),
        initialState: dashatarThemeState,
      );

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets(
        'adds PuzzleReset to PuzzleBloc '
        'when isCountdownRunning is true and '
        'secondsToBegin is between 1 and 3 (inclusive)', (WidgetTester tester) async {
      final MockPuzzleBloc puzzleBloc = MockPuzzleBloc();

      final DashatarPuzzleState state = DashatarPuzzleState(
        isCountdownRunning: true,
        secondsToBegin: 4,
      );

      final StreamController<DashatarPuzzleState> streamController = StreamController<DashatarPuzzleState>();

      whenListen(
        dashatarPuzzleBloc,
        streamController.stream,
      );

      streamController
        ..add(state)
        ..add(state.copyWith(secondsToBegin: 3))
        ..add(state.copyWith(secondsToBegin: 2))
        ..add(state.copyWith(secondsToBegin: 1))
        ..add(state.copyWith(secondsToBegin: 0))
        ..add(state.copyWith(isCountdownRunning: false));

      await tester.pumpApp(
        DashatarCountdown(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        audioControlBloc: audioControlBloc,
      );

      verify(() => puzzleBloc.add(PuzzleReset())).called(3);
    });

    testWidgets(
        'plays the shuffle sound '
        'when secondsToBegin is 3', (WidgetTester tester) async {
      final MockAudioPlayer audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.stop).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});

      final DashatarPuzzleState state = DashatarPuzzleState(
        isCountdownRunning: true,
        secondsToBegin: 3,
      );

      whenListen(
        dashatarPuzzleBloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpApp(
        DashatarCountdown(
          audioPlayer: () => audioPlayer,
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      verify(() => audioPlayer.setAsset('assets/audio/shuffle_board.mp3')).called(1);
      verify(audioPlayer.play).called(1);
    });

    group('on a large display', () {
      testWidgets(
          'renders DashatarCountdownSecondsToBegin '
          'if isCountdownRunning is true and '
          'secondsToBegin is greater than 0', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        final DashatarPuzzleState state = DashatarPuzzleState(
          isCountdownRunning: true,
          secondsToBegin: 3,
        );

        whenListen(
          dashatarPuzzleBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          DashatarCountdown(),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is DashatarCountdownSecondsToBegin &&
                widget.secondsToBegin == state.secondsToBegin,
          ),
          findsOneWidget,
        );

        expect(find.byType(DashatarCountdownGo), findsNothing);
      });

      testWidgets(
          'renders DashatarCountdownGo '
          'if isCountdownRunning is true and '
          'secondsToBegin is equal to 0', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        final DashatarPuzzleState state = DashatarPuzzleState(
          isCountdownRunning: true,
          secondsToBegin: 0,
        );

        whenListen(
          dashatarPuzzleBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          DashatarCountdown(),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarCountdownSecondsToBegin), findsNothing);
        expect(find.byType(DashatarCountdownGo), findsOneWidget);
      });

      testWidgets(
          'renders SizedBox '
          'if isCountdownRunning is false', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        final DashatarPuzzleState state = DashatarPuzzleState(
          isCountdownRunning: false,
          secondsToBegin: 3,
        );

        whenListen(
          dashatarPuzzleBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          DashatarCountdown(),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(DashatarCountdownSecondsToBegin), findsNothing);
        expect(find.byType(DashatarCountdownGo), findsNothing);
      });

      testWidgets(
          'renders SizedBox '
          'if secondsToBegin is greater than 3', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        final DashatarPuzzleState state = DashatarPuzzleState(
          isCountdownRunning: true,
          secondsToBegin: 4,
        );

        whenListen(
          dashatarPuzzleBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          DashatarCountdown(),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(DashatarCountdownSecondsToBegin), findsNothing);
        expect(find.byType(DashatarCountdownGo), findsNothing);
      });
    });

    testWidgets('renders SizedBox on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        DashatarCountdown(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(DashatarCountdownSecondsToBegin), findsNothing);
      expect(find.byType(DashatarCountdownGo), findsNothing);
    });

    testWidgets('renders SizedBox on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        DashatarCountdown(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(DashatarCountdownSecondsToBegin), findsNothing);
      expect(find.byType(DashatarCountdownGo), findsNothing);
    });

    testWidgets('renders AudioControlListener', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarCountdown(),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(AudioControlListener), findsOneWidget);
    });
  });

  group('DashatarCountdownSecondsToBegin', () {
    late DashatarThemeBloc dashatarThemeBloc;
    late DashatarTheme dashatarTheme;

    setUp(() {
      dashatarThemeBloc = MockDashatarThemeBloc();
      dashatarTheme = MockDashatarTheme();
      final DashatarThemeState dashatarThemeState = DashatarThemeState(
        themes: <DashatarTheme>[dashatarTheme],
        theme: dashatarTheme,
      );

      when(() => dashatarTheme.defaultColor).thenReturn(Colors.black);
      when(() => dashatarTheme.countdownColor).thenReturn(Colors.black);
      when(() => dashatarThemeBloc.state).thenReturn(dashatarThemeState);
    });

    testWidgets(
        'renders secondsToBegin '
        'using DashatarTheme.countdownColor as text color', (WidgetTester tester) async {
      const MaterialColor countdownColor = Colors.green;
      when(() => dashatarTheme.countdownColor).thenReturn(countdownColor);

      await tester.pumpApp(
        DashatarCountdownSecondsToBegin(
          secondsToBegin: 3,
        ),
        dashatarThemeBloc: dashatarThemeBloc,
      );

      final Text text = tester.widget<Text>(find.text('3'));

      expect(text.style?.color, equals(countdownColor));
    });
  });

  group('DashatarCountdownGo', () {
    late DashatarThemeBloc dashatarThemeBloc;
    late DashatarTheme dashatarTheme;

    setUp(() {
      dashatarThemeBloc = MockDashatarThemeBloc();
      dashatarTheme = MockDashatarTheme();
      final DashatarThemeState themeState = DashatarThemeState(
        themes: <DashatarTheme>[dashatarTheme],
        theme: dashatarTheme,
      );

      when(() => dashatarTheme.defaultColor).thenReturn(Colors.black);
      when(() => dashatarTheme.countdownColor).thenReturn(Colors.black);
      when(() => dashatarThemeBloc.state).thenReturn(themeState);
    });

    testWidgets(
        'renders text '
        'using DashatarTheme.defaultColor as text color', (WidgetTester tester) async {
      const MaterialColor defaultColor = Colors.orange;
      when(() => dashatarTheme.defaultColor).thenReturn(defaultColor);

      await tester.pumpApp(
        DashatarCountdownGo(),
        dashatarThemeBloc: dashatarThemeBloc,
      );

      final Text text = tester.widget<Text>(find.byType(Text));

      expect(text.style?.color, equals(defaultColor));
    });
  });
}
