// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarStartSection', () {
    late DashatarPuzzleBloc dashatarPuzzleBloc;
    late DashatarPuzzleState dashatarPuzzleState;
    late DashatarThemeBloc dashatarThemeBloc;
    late DashatarTheme dashatarTheme;
    late ThemeBloc themeBloc;
    late TimerBloc timerBloc;
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
      dashatarTheme = LittoralDashatarTheme();
      final DashatarThemeState dashatarThemeState = DashatarThemeState(
        themes: <DashatarTheme>[dashatarTheme],
        theme: dashatarTheme,
      );

      when(() => dashatarThemeBloc.state).thenReturn(dashatarThemeState);

      final SimpleTheme theme = SimpleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);
      themeBloc = MockThemeBloc();

      when(() => themeBloc.state).thenReturn(themeState);

      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets('renders PuzzleName', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: PuzzleState(),
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(find.byType(PuzzleName), findsOneWidget);
    });

    testWidgets('renders PuzzleTitle', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: PuzzleState(),
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(find.byType(PuzzleTitle), findsOneWidget);
    });

    testWidgets(
        'renders NumberOfMovesAndTilesLeft '
        'when DashatarPuzzleStatus is started', (WidgetTester tester) async {
      const int numberOfMoves = 10;
      const int numberOfTilesLeft = 12;

      final MockPuzzleState puzzleState = MockPuzzleState();
      when(() => puzzleState.numberOfMoves).thenReturn(numberOfMoves);
      when(() => puzzleState.numberOfTilesLeft).thenReturn(numberOfTilesLeft);

      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.started);

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: puzzleState,
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is NumberOfMovesAndTilesLeft &&
              widget.numberOfMoves == numberOfMoves &&
              widget.numberOfTilesLeft == numberOfTilesLeft,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders NumberOfMovesAndTilesLeft '
        'when DashatarPuzzleStatus is notStarted', (WidgetTester tester) async {
      const int numberOfMoves = 10;
      const int numberOfTiles = 16;

      final MockPuzzleState puzzleState = MockPuzzleState();
      when(() => puzzleState.numberOfMoves).thenReturn(numberOfMoves);

      final MockPuzzle puzzle = MockPuzzle();
      when(() => puzzle.tiles)
          .thenReturn(List.generate(numberOfTiles, (_) => MockTile()));
      when(() => puzzleState.puzzle).thenReturn(puzzle);

      when(() => dashatarPuzzleState.status)
          .thenReturn(DashatarPuzzleStatus.loading);

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: puzzleState,
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is NumberOfMovesAndTilesLeft &&
              widget.numberOfMoves == numberOfMoves &&
              widget.numberOfTilesLeft == numberOfTiles - 1,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarPuzzleActionButton on a large display',
        (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: PuzzleState(),
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(DashatarPuzzleActionButton), findsOneWidget);
      expect(find.byType(DashatarTimer), findsNothing);
    });

    testWidgets('renders DashatarTimer on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: PuzzleState(),
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(find.byType(DashatarPuzzleActionButton), findsNothing);
      expect(find.byType(DashatarTimer), findsOneWidget);
    });

    testWidgets('renders DashatarTimer on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarStartSection(
            state: PuzzleState(),
          ),
        ),
        dashatarPuzzleBloc: dashatarPuzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        themeBloc: themeBloc,
        timerBloc: timerBloc,
      );

      expect(find.byType(DashatarPuzzleActionButton), findsNothing);
      expect(find.byType(DashatarTimer), findsOneWidget);
    });
  });
}
