// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/layout/layout.dart';
import 'package:spozzle/models/tile.dart';
import 'package:spozzle/puzzle/puzzle.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PuzzlePage', () {
    testWidgets('renders PuzzleView', (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());
      expect(find.byType(PuzzleView), findsOneWidget);
    });

    testWidgets('provides all Dashatar themes to PuzzleView', (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());

      final BuildContext puzzleViewContext =
          tester.element(find.byType(PuzzleView));

      final List<DashatarTheme> dashatarThemes =
          puzzleViewContext.read<DashatarThemeBloc>().state.themes;

      expect(
        dashatarThemes,
        equals(<DashatarTheme>[
          WestDashatarTheme(),
          LittoralDashatarTheme(),
          NorthDashatarTheme(),
        ]),
      );
    });

    testWidgets('provides correct initial themes to PuzzleView',
        (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());

      final BuildContext puzzleViewContext =
          tester.element(find.byType(PuzzleView));

      final List<PuzzleTheme> initialThemes = puzzleViewContext.read<ThemeBloc>().state.themes;

      expect(
        initialThemes,
        equals(<PuzzleTheme>[
          SimpleTheme(),
          LittoralDashatarTheme(),
        ]),
      );
    });

    testWidgets(
        'provides DashatarPuzzleBloc '
        'with secondsToBegin equal to 3', (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());

      final BuildContext puzzleViewContext =
          tester.element(find.byType(PuzzleView));

      final int secondsToBegin =
          puzzleViewContext.read<DashatarPuzzleBloc>().state.secondsToBegin;

      expect(
        secondsToBegin,
        equals(3),
      );
    });

    testWidgets(
        'provides TimerBloc '
        'with initial state', (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());

      final BuildContext puzzleViewContext =
          tester.element(find.byType(PuzzleView));

      expect(
        puzzleViewContext.read<TimerBloc>().state,
        equals(TimerState()),
      );
    });

    testWidgets(
        'provides AudioControlBloc '
        'with initial state', (WidgetTester tester) async {
      await tester.pumpApp(PuzzlePage());

      final BuildContext puzzleViewContext =
          tester.element(find.byType(PuzzleView));

      expect(
        puzzleViewContext.read<AudioControlBloc>().state,
        equals(AudioControlState()),
      );
    });
  });

  group('PuzzleView', () {
    late ThemeBloc themeBloc;
    late PuzzleTheme theme;
    late DashatarThemeBloc dashatarThemeBloc;
    late PuzzleLayoutDelegate layoutDelegate;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      theme = MockPuzzleTheme();
      final ThemeState themeState = ThemeState(themes: <PuzzleTheme>[theme], theme: theme);
      themeBloc = MockThemeBloc();
      layoutDelegate = MockPuzzleLayoutDelegate();

      when(() => layoutDelegate.startSectionBuilder(any()))
          .thenReturn(SizedBox());

      when(() => layoutDelegate.endSectionBuilder(any()))
          .thenReturn(SizedBox());

      when(() => layoutDelegate.backgroundBuilder(any()))
          .thenReturn(SizedBox());

      when(() => layoutDelegate.boardBuilder(any(), any()))
          .thenReturn(SizedBox());

      when(() => layoutDelegate.tileBuilder(any(), any()))
          .thenReturn(SizedBox());

      when(layoutDelegate.whitespaceTileBuilder).thenReturn(SizedBox());

      when(() => theme.layoutDelegate).thenReturn(layoutDelegate);
      when(() => theme.backgroundColor).thenReturn(Colors.black);
      when(() => theme.isLogoColored).thenReturn(true);
      when(() => theme.menuActiveColor).thenReturn(Colors.black);
      when(() => theme.menuUnderlineColor).thenReturn(Colors.black);
      when(() => theme.menuInactiveColor).thenReturn(Colors.black);
      when(() => theme.hasTimer).thenReturn(true);
      when(() => theme.name).thenReturn('Name');
      when(() => theme.audioControlOnAsset)
          .thenReturn('assets/images/audio_control/simple_on.png');
      when(() => theme.audioControlOffAsset)
          .thenReturn('assets/images/audio_control/simple_off.png');
      when(() => themeBloc.state).thenReturn(themeState);

      dashatarThemeBloc = MockDashatarThemeBloc();
      when(() => dashatarThemeBloc.state)
          .thenReturn(DashatarThemeState(themes: <DashatarTheme>[LittoralDashatarTheme()]));

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    setUpAll(() {
      registerFallbackValue(MockPuzzleState());
      registerFallbackValue(MockTile());
    });

    testWidgets(
        'adds ThemeUpdated to ThemeBloc '
        'when DashatarTheme changes', (WidgetTester tester) async {
      final List<DashatarTheme> themes = <DashatarTheme>[LittoralDashatarTheme(), WestDashatarTheme()];

      whenListen(
        dashatarThemeBloc,
        Stream.fromIterable(<DashatarThemeState>[
          DashatarThemeState(themes: themes, theme: LittoralDashatarTheme()),
          DashatarThemeState(themes: themes, theme: WestDashatarTheme()),
        ]),
      );

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      verify(() => themeBloc.add(ThemeUpdated(theme: LittoralDashatarTheme())))
          .called(1);

      verify(() => themeBloc.add(ThemeUpdated(theme: WestDashatarTheme())))
          .called(1);
    });

    testWidgets(
        'renders Scaffold with descendant AnimatedContainer  '
        'using PuzzleTheme.backgroundColor as background color',
        (WidgetTester tester) async {
      const MaterialColor backgroundColor = Colors.orange;
      when(() => theme.backgroundColor).thenReturn(backgroundColor);

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byWidgetPredicate(
            (Widget widget) =>
                widget is AnimatedContainer &&
                widget.decoration == BoxDecoration(color: backgroundColor),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders puzzle correctly '
        'on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byKey(Key('puzzle_view_puzzle')), findsOneWidget);
    });

    testWidgets(
        'renders puzzle correctly '
        'on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byKey(Key('puzzle_view_puzzle')), findsOneWidget);
    });

    testWidgets(
        'renders puzzle correctly '
        'on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byKey(Key('puzzle_view_puzzle')), findsOneWidget);
    });

    testWidgets('renders PuzzleHeader', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(PuzzleHeader), findsOneWidget);
    });

    testWidgets('renders puzzle sections', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(PuzzleSections), findsOneWidget);
    });

    testWidgets(
        'builds background '
        'with layoutDelegate.backgroundBuilder', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      verify(() => layoutDelegate.backgroundBuilder(any())).called(1);
    });

    testWidgets(
        'builds board '
        'with layoutDelegate.boardBuilder', (WidgetTester tester) async {
      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.pumpAndSettle();

      verify(() => layoutDelegate.boardBuilder(any(), any())).called(1);
    });

    testWidgets(
        'builds 15 tiles '
        'with layoutDelegate.tileBuilder', (WidgetTester tester) async {
      when(() => layoutDelegate.boardBuilder(any(), any()))
          .thenAnswer((Invocation invocation) {
        final List<Widget> tiles = invocation.positionalArguments[1] as List<Widget>;
        return Row(children: tiles);
      });

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.pumpAndSettle();

      verify(() => layoutDelegate.tileBuilder(any(), any())).called(15);
    });

    testWidgets(
        'builds 1 whitespace tile '
        'with layoutDelegate.whitespaceTileBuilder', (WidgetTester tester) async {
      when(() => layoutDelegate.boardBuilder(any(), any()))
          .thenAnswer((Invocation invocation) {
        final List<Widget> tiles = invocation.positionalArguments[1] as List<Widget>;
        return Row(children: tiles);
      });

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.pumpAndSettle();

      verify(layoutDelegate.whitespaceTileBuilder).called(1);
    });

    testWidgets(
        'may start a timer '
        'in layoutDelegate', (WidgetTester tester) async {
      when(() => layoutDelegate.startSectionBuilder(any()))
          .thenAnswer((Invocation invocation) {
        return Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () => context.read<TimerBloc>().add(TimerStarted()),
              key: Key('__start_timer__'),
              child: Text('Start timer'),
            );
          },
        );
      });

      await tester.pumpApp(
        PuzzleView(),
        themeBloc: themeBloc,
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('__start_timer__')));
    });

    group('PuzzleHeader', () {
      testWidgets(
          'renders PuzzleLogo and PuzzleMenu '
          'on a large display', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          PuzzleHeader(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(PuzzleLogo), findsOneWidget);
        expect(find.byType(PuzzleMenu), findsOneWidget);
      });

      testWidgets(
          'renders PuzzleLogo and PuzzleMenu '
          'on a medium display', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          PuzzleHeader(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(PuzzleLogo), findsOneWidget);
        expect(find.byType(PuzzleMenu), findsOneWidget);
      });

      testWidgets(
          'renders PuzzleLogo and AudioControl '
          'on a small display', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          PuzzleHeader(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(PuzzleLogo), findsOneWidget);
        expect(find.byType(PuzzleMenu), findsNothing);
        expect(find.byType(AudioControl), findsOneWidget);
      });
    });

    group('PuzzleSections', () {
      late PuzzleBloc puzzleBloc;

      setUp(() {
        final MockPuzzleState puzzleState = MockPuzzleState();
        final MockPuzzle puzzle = MockPuzzle();
        puzzleBloc = MockPuzzleBloc();

        when(puzzle.getDimension).thenReturn(4);
        when(() => puzzle.tiles).thenReturn(<Tile>[]);
        when(() => puzzleState.puzzle).thenReturn(puzzle);
        when(() => puzzleState.puzzleStatus).thenReturn(PuzzleStatus.complete);
        whenListen(
          puzzleBloc,
          Stream.value(puzzleState),
          initialState: puzzleState,
        );
      });

      group('on a large display', () {
        testWidgets(
            'builds start section '
            'with layoutDelegate.startSectionBuilder', (WidgetTester tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.startSectionBuilder(any())).called(1);
        });

        testWidgets(
            'builds end section '
            'with layoutDelegate.endSectionBuilder', (WidgetTester tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.endSectionBuilder(any())).called(1);
        });

        testWidgets('renders PuzzleBoard', (WidgetTester tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(PuzzleBoard), findsOneWidget);
        });
      });

      group('on a medium display', () {
        testWidgets(
            'builds start section '
            'with layoutDelegate.startSectionBuilder', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.startSectionBuilder(any())).called(1);
        });

        testWidgets(
            'builds end section '
            'with layoutDelegate.endSectionBuilder', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.endSectionBuilder(any())).called(1);
        });

        testWidgets('renders PuzzleBoard', (WidgetTester tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(PuzzleBoard), findsOneWidget);
        });
      });

      group('on a small display', () {
        testWidgets(
            'builds start section '
            'with layoutDelegate.startSectionBuilder', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.startSectionBuilder(any())).called(1);
        });

        testWidgets(
            'builds end section '
            'with layoutDelegate.endSectionBuilder', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          verify(() => layoutDelegate.endSectionBuilder(any())).called(1);
        });

        testWidgets('renders PuzzleMenu', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(PuzzleMenu), findsOneWidget);
        });

        testWidgets('renders PuzzleBoard', (WidgetTester tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            PuzzleSections(),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(PuzzleBoard), findsOneWidget);
        });
      });
    });

    group('PuzzleBoard', () {
      late PuzzleBloc puzzleBloc;

      setUp(() {
        puzzleBloc = MockPuzzleBloc();
        final MockPuzzleState puzzleState = MockPuzzleState();
        final MockPuzzle puzzle = MockPuzzle();

        when(puzzle.getDimension).thenReturn(4);
        when(() => puzzle.tiles).thenReturn(<Tile>[]);
        when(() => puzzleState.puzzle).thenReturn(puzzle);
        when(() => puzzleState.puzzleStatus).thenReturn(PuzzleStatus.complete);
        whenListen(
          puzzleBloc,
          Stream.value(puzzleState),
          initialState: puzzleState,
        );
      });

      testWidgets(
          'adds TimerStopped to TimerBloc '
          'when the puzzle completes', (WidgetTester tester) async {
        final MockTimerBloc timerBloc = MockTimerBloc();
        final MockTimerState timerState = MockTimerState();

        const int secondsElapsed = 60;
        when(() => timerState.secondsElapsed).thenReturn(secondsElapsed);
        when(() => timerBloc.state).thenReturn(timerState);

        await tester.pumpApp(
          PuzzleBoard(),
          themeBloc: themeBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          audioControlBloc: audioControlBloc,
          timerBloc: timerBloc,
          puzzleBloc: puzzleBloc,
        );

        verify(() => timerBloc.add(TimerStopped())).called(1);
      });

      testWidgets('renders PuzzleKeyboardHandler', (WidgetTester tester) async {
        await tester.pumpApp(
          PuzzleBoard(),
          themeBloc: themeBloc,
          puzzleBloc: puzzleBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(PuzzleKeyboardHandler), findsOneWidget);
      });
    });

    group('PuzzleMenu', () {
      testWidgets(
          'renders PuzzleMenuItem '
          'for each theme in ThemeState', (WidgetTester tester) async {
        final List<PuzzleTheme> themes = <PuzzleTheme>[SimpleTheme(), LittoralDashatarTheme()];
        final ThemeState themeState = ThemeState(themes: themes, theme: themes[1]);
        when(() => themeBloc.state).thenReturn(themeState);

        await tester.pumpApp(
          PuzzleMenu(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(PuzzleMenuItem), findsNWidgets(themes.length));

        for (final PuzzleTheme theme in themes) {
          expect(
            find.byWidgetPredicate(
              (Widget widget) => widget is PuzzleMenuItem && widget.theme == theme,
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets('renders AudioControl on a large display', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          PuzzleMenu(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(AudioControl), findsOneWidget);
      });

      testWidgets('renders AudioControl on a medium display', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          PuzzleMenu(),
          themeBloc: themeBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(AudioControl), findsOneWidget);
      });
    });

    group('PuzzleMenuItem', () {
      late PuzzleTheme tappedTheme;
      late List<PuzzleTheme> themes;
      late ThemeState themeState;

      setUp(() {
        tappedTheme = LittoralDashatarTheme();
        themes = <PuzzleTheme>[SimpleTheme(), tappedTheme];
        themeState = ThemeState(themes: themes, theme: SimpleTheme());

        when(() => themeBloc.state).thenReturn(themeState);
      });

      group('when tapped', () {
        testWidgets('adds ThemeChanged to ThemeBloc', (WidgetTester tester) async {
          await tester.pumpApp(
            PuzzleMenuItem(
              theme: tappedTheme,
              themeIndex: themes.indexOf(tappedTheme),
            ),
            themeBloc: themeBloc,
          );

          await tester.tap(find.byType(PuzzleMenuItem));

          verify(() => themeBloc.add(ThemeChanged(themeIndex: 1))).called(1);
        });

        testWidgets('adds TimerReset to TimerBloc', (WidgetTester tester) async {
          final MockTimerBloc timerBloc = MockTimerBloc();

          await tester.pumpApp(
            PuzzleMenuItem(
              theme: tappedTheme,
              themeIndex: themes.indexOf(tappedTheme),
            ),
            themeBloc: themeBloc,
            timerBloc: timerBloc,
          );

          await tester.tap(find.byType(PuzzleMenuItem));

          verify(() => timerBloc.add(TimerReset())).called(1);
        });

        testWidgets('adds DashatarCountdownStopped to DashatarPuzzleBloc',
            (WidgetTester tester) async {
          final MockDashatarPuzzleBloc dashatarPuzzleBloc = MockDashatarPuzzleBloc();

          await tester.pumpApp(
            PuzzleMenuItem(
              theme: tappedTheme,
              themeIndex: themes.indexOf(tappedTheme),
            ),
            themeBloc: themeBloc,
            dashatarPuzzleBloc: dashatarPuzzleBloc,
          );

          await tester.tap(find.byType(PuzzleMenuItem));

          verify(() => dashatarPuzzleBloc.add(DashatarCountdownStopped()))
              .called(1);
        });

        testWidgets(
            'adds PuzzleInitialized to PuzzleBloc '
            'with shufflePuzzle equal to true '
            'if theme is SimpleTheme', (WidgetTester tester) async {
          final MockPuzzleBloc puzzleBloc = MockPuzzleBloc();

          when(() => themeBloc.state).thenReturn(
            ThemeState(
              themes: themes,
              theme: LittoralDashatarTheme(),
            ),
          );

          await tester.pumpApp(
            PuzzleMenuItem(
              theme: SimpleTheme(),
              themeIndex: themes.indexOf(SimpleTheme()),
            ),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
          );

          await tester.tap(find.byType(PuzzleMenuItem));

          verify(() => puzzleBloc.add(PuzzleInitialized(shufflePuzzle: true)))
              .called(1);
        });

        testWidgets(
            'adds PuzzleInitialized to PuzzleBloc '
            'with shufflePuzzle equal to false '
            'if current theme is not SimpleTheme', (WidgetTester tester) async {
          final MockPuzzleBloc puzzleBloc = MockPuzzleBloc();

          when(() => themeBloc.state).thenReturn(
            ThemeState(
              themes: themes,
              theme: SimpleTheme(),
            ),
          );

          await tester.pumpApp(
            PuzzleMenuItem(
              theme: LittoralDashatarTheme(),
              themeIndex: themes.indexOf(LittoralDashatarTheme()),
            ),
            themeBloc: themeBloc,
            puzzleBloc: puzzleBloc,
          );

          await tester.tap(find.byType(PuzzleMenuItem));

          verify(() => puzzleBloc.add(PuzzleInitialized(shufflePuzzle: false)))
              .called(1);
        });
      });

      testWidgets('renders Tooltip', (WidgetTester tester) async {
        await tester.pumpApp(
          PuzzleMenuItem(
            theme: tappedTheme,
            themeIndex: themes.indexOf(tappedTheme),
          ),
          themeBloc: themeBloc,
        );

        expect(find.byType(Tooltip), findsOneWidget);
      });

      testWidgets('renders theme name', (WidgetTester tester) async {
        await tester.pumpApp(
          PuzzleMenuItem(
            theme: tappedTheme,
            themeIndex: themes.indexOf(tappedTheme),
          ),
          themeBloc: themeBloc,
        );

        expect(find.text(tappedTheme.name), findsOneWidget);
      });
    });
  });
}
