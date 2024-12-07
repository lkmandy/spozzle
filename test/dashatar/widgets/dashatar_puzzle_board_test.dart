// ignore_for_file: prefer_const_constructors,
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarPuzzleBoard', () {
    late PuzzleBloc puzzleBloc;
    late PuzzleState puzzleState;

    setUp(() {
      puzzleBloc = MockPuzzleBloc();
      puzzleState = MockPuzzleState();

      when(() => puzzleState.puzzleStatus).thenReturn(PuzzleStatus.incomplete);
      whenListen(
        puzzleBloc,
        Stream.value(puzzleState),
        initialState: puzzleState,
      );
    });

    testWidgets(
        'shows DashatarShareDialog '
        'when PuzzleStatus is complete', (WidgetTester tester) async {
      final DashatarThemeBloc dashatarThemeBloc =
          DashatarThemeBloc(themes: <DashatarTheme>[LittoralDashatarTheme()]);
      final MockTimerBloc timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());
      final StreamController<PuzzleState> controller = StreamController<PuzzleState>()..add(PuzzleState());

      final MockAudioControlBloc audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());

      whenListen(
        puzzleBloc,
        controller.stream,
      );

      await tester.pumpApp(
        DashatarPuzzleBoard(tiles: <Widget>[]),
        puzzleBloc: puzzleBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(DashatarShareDialog), findsNothing);

      controller.add(PuzzleState(puzzleStatus: PuzzleStatus.complete));

      // Wait for the dialog to appear.
      await tester.pump(const Duration(milliseconds: 370));

      // Wait for the dialog to animate.
      await tester.pump(const Duration(milliseconds: 140));

      expect(find.byType(DashatarShareDialog), findsOneWidget);
    });

    testWidgets('renders Stack with tiles', (WidgetTester tester) async {
      final List<SizedBox> tiles = <SizedBox>[
        SizedBox(key: Key('__sized_box_1__')),
        SizedBox(key: Key('__sized_box_2__')),
      ];

      await tester.pumpApp(
        DashatarPuzzleBoard(tiles: tiles),
        puzzleBloc: puzzleBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Stack && widget.children == tiles,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders a large board on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        DashatarPuzzleBoard(tiles: <Widget>[]),
        puzzleBloc: puzzleBloc,
      );

      expect(find.byKey(Key('dashatar_puzzle_board_large')), findsOneWidget);
    });

    testWidgets('renders a medium board on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        DashatarPuzzleBoard(tiles: <Widget>[]),
        puzzleBloc: puzzleBloc,
      );

      expect(find.byKey(Key('dashatar_puzzle_board_medium')), findsOneWidget);
    });

    testWidgets('renders a small board on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        DashatarPuzzleBoard(tiles: <Widget>[]),
        puzzleBloc: puzzleBloc,
      );

      expect(find.byKey(Key('dashatar_puzzle_board_small')), findsOneWidget);
    });
  });
}
