// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarShareDialog', () {
    late DashatarThemeBloc dashatarThemeBloc;
    late PuzzleBloc puzzleBloc;
    late TimerBloc timerBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      dashatarThemeBloc = MockDashatarThemeBloc();
      when(() => dashatarThemeBloc.state).thenReturn(
        DashatarThemeState(themes: <DashatarTheme>[LittoralDashatarTheme()]),
      );

      puzzleBloc = MockPuzzleBloc();
      when(() => puzzleBloc.state).thenReturn(PuzzleState());

      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byKey(Key('dashatar_share_dialog')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byKey(Key('dashatar_share_dialog')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byKey(Key('dashatar_share_dialog')),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarShareDialogAnimatedBuilder', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byType(DashatarShareDialogAnimatedBuilder),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarScore', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byType(DashatarScore),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarShareYourScore', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byType(DashatarShareYourScore),
        findsOneWidget,
      );
    });

    testWidgets('renders close button', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byKey(Key('dashatar_share_dialog_close_button')),
        findsOneWidget,
      );
    });

    testWidgets('renders AudioControlListeners', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      expect(
        find.byKey(Key('dashatar_share_dialog_success_audio_player')),
        findsOneWidget,
      );

      expect(
        find.byKey(Key('dashatar_share_dialog_click_audio_player')),
        findsOneWidget,
      );
    });

    testWidgets('pops when tapped on close button', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DashatarShareDialog(),
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        puzzleBloc: puzzleBloc,
        timerBloc: timerBloc,
        audioControlBloc: audioControlBloc,
      );

      // Wait for the animation to complete.
      await tester.pump(Duration(milliseconds: 1100 + 140));

      await tester.tap(find.byKey(Key('dashatar_share_dialog_close_button')));
      await tester.pumpAndSettle();

      expect(find.byType(DashatarShareDialog), findsNothing);
    });
  });
}
