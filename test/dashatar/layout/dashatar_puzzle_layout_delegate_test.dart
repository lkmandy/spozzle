// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/models/models.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarPuzzleLayoutDelegate', () {
    late DashatarPuzzleLayoutDelegate layoutDelegate;
    late DashatarPuzzleBloc dashatarPuzzleBloc;
    late DashatarThemeBloc dashatarThemeBloc;
    late ThemeBloc themeBloc;
    late PuzzleBloc puzzleBloc;
    late PuzzleState state;
    late TimerBloc timerBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      layoutDelegate = DashatarPuzzleLayoutDelegate();

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

      themeBloc = MockThemeBloc();
      final LittoralDashatarTheme theme = LittoralDashatarTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);
      when(() => themeBloc.state).thenReturn(themeState);

      puzzleBloc = MockPuzzleBloc();
      state = PuzzleState();
      when(() => puzzleBloc.state).thenReturn(state);

      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    group('startSectionBuilder', () {
      testWidgets(
          'renders DashatarStartSection '
          'on a large display', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(state),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarStartSection '
          'on a medium display', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(state),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarStartSection '
          'on a small display', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(state),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });
    });

    group('endSectionBuilder', () {
      group('on a large display', () {
        testWidgets(
            'does not render DashatarPuzzleActionButton and '
            'DashatarThemePicker', (WidgetTester tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsNothing);
          expect(find.byType(DashatarThemePicker), findsNothing);
        });

        testWidgets('renders DashatarCountdown', (WidgetTester tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });

      group('on a medium display', () {
        testWidgets('renders DashatarPuzzleActionButton', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsOneWidget);
        });

        testWidgets('renders DashatarThemePicker', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarThemePicker), findsOneWidget);
        });

        testWidgets('renders DashatarCountdown', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });

      group('on a small display', () {
        testWidgets('renders DashatarPuzzleActionButton', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsOneWidget);
        });

        testWidgets('renders DashatarThemePicker', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarThemePicker), findsOneWidget);
        });

        testWidgets('renders DashatarCountdown', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(state),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });
    });

    group('backgroundBuilder', () {
      testWidgets(
          'renders DashatarThemePicker '
          'on a large display', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          Stack(
            children: <Widget>[
              layoutDelegate.backgroundBuilder(state),
            ],
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsOneWidget);
      });

      testWidgets(
          'renders SizedBox '
          'on a medium display', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          Stack(
            children: <Widget>[
              layoutDelegate.backgroundBuilder(state),
            ],
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets(
          'renders SizedBox '
          'on a small display', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          Stack(
            children: <Widget>[
              layoutDelegate.backgroundBuilder(state),
            ],
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('boardBuilder', () {
      final List<SizedBox> tiles = <SizedBox>[
        const SizedBox(),
      ];

      testWidgets(
          'renders DashatarTimer and DashatarPuzzleBoard '
          'on a large display', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.boardBuilder(4, tiles),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarPuzzleBoard '
          'on a medium display', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.boardBuilder(4, tiles),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsNothing);
        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarPuzzleBoard '
          'on a small display', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          SingleChildScrollView(
            child: layoutDelegate.boardBuilder(4, tiles),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsNothing);
        expect(
          find.byWidgetPredicate(
            (Widget widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });
    });

    group('tileBuilder', () {
      testWidgets('renders DashatarPuzzleTile', (WidgetTester tester) async {
        final Tile tile = Tile(
          value: 1,
          correctPosition: Position(x: 1, y: 1),
          currentPosition: Position(x: 1, y: 2),
        );

        await tester.pumpApp(
          Material(
            child: layoutDelegate.tileBuilder(tile, state),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is DashatarPuzzleTile &&
                widget.tile == tile &&
                widget.state == state,
          ),
          findsOneWidget,
        );
      });
    });

    group('whitespaceTileBuilder', () {
      testWidgets('renders SizedBox', (WidgetTester tester) async {
        await tester.pumpApp(
          layoutDelegate.whitespaceTileBuilder(),
        );

        expect(
          find.byType(SizedBox),
          findsOneWidget,
        );
      });
    });

    test('supports value comparisons', () {
      expect(
        DashatarPuzzleLayoutDelegate(),
        equals(DashatarPuzzleLayoutDelegate()),
      );
    });
  });
}
