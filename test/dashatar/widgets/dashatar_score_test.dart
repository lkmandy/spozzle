// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarScore', () {
    late DashatarThemeBloc dashatarThemeBloc;
    late PuzzleBloc puzzleBloc;
    late TimerBloc timerBloc;

    setUp(() {
      dashatarThemeBloc = MockDashatarThemeBloc();
      when(() => dashatarThemeBloc.state).thenReturn(
        DashatarThemeState(themes: <DashatarTheme>[LittoralDashatarTheme()]),
      );

      puzzleBloc = MockPuzzleBloc();
      when(() => puzzleBloc.state).thenReturn(PuzzleState());

      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders successThemeAsset from DashatarTheme', (WidgetTester tester) async {
      const WestDashatarTheme theme = WestDashatarTheme();

      when(() => dashatarThemeBloc.state).thenReturn(
        DashatarThemeState(
          themes: <DashatarTheme>[LittoralDashatarTheme(), theme],
          theme: theme,
        ),
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              (widget.image as AssetImage).assetName == theme.successThemeAsset,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders AppFlutterLogo', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byType(AppFlutterLogo),
        findsOneWidget,
      );
    });

    testWidgets('renders completed text', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score_completed')),
        findsOneWidget,
      );
    });

    testWidgets('renders well done text', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score_well_done')),
        findsOneWidget,
      );
    });

    testWidgets('renders score text', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarTimer', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byType(DashatarTimer),
        findsOneWidget,
      );
    });

    testWidgets('renders number of moves text', (WidgetTester tester) async {
      const int numberOfMoves = 14;
      when(() => puzzleBloc.state).thenReturn(
        PuzzleState(
          numberOfMoves: numberOfMoves,
        ),
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarScore(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_score_number_of_moves')),
        findsOneWidget,
      );

      expect(
        find.textContaining(numberOfMoves.toString()),
        findsOneWidget,
      );
    });
  });
}
