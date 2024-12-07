// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarThemePicker', () {
    late DashatarThemeBloc dashatarThemeBloc;
    late DashatarTheme dashatarTheme;
    late List<DashatarTheme> dashatarThemes;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      dashatarThemeBloc = MockDashatarThemeBloc();
      dashatarThemes = <DashatarTheme>[
        LittoralDashatarTheme(),
        NorthDashatarTheme(),
        WestDashatarTheme()
      ];
      dashatarTheme = LittoralDashatarTheme();
      final DashatarThemeState dashatarThemeState = DashatarThemeState(
        themes: dashatarThemes,
        theme: dashatarTheme,
      );

      when(() => dashatarThemeBloc.state).thenReturn(dashatarThemeState);

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_theme_picker')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_theme_picker')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_theme_picker')),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Image with a theme asset '
        'for each Dashatar theme', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      for (final DashatarTheme dashatarTheme in dashatarThemes) {
        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is Image &&
                (widget.image as AssetImage).assetName ==
                    dashatarTheme.themeAsset,
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('renders AudioControlListener', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(find.byType(AudioControlListener), findsOneWidget);
    });

    testWidgets(
        'each Image has semanticLabel '
        'from DashatarTheme.semanticsLabel', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      final BuildContext context =
          tester.element(find.byType(DashatarThemePicker));

      for (final DashatarTheme dashatarTheme in dashatarThemes) {
        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is Image &&
                widget.semanticLabel == dashatarTheme.semanticsLabel(context),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets(
        'adds DashatarThemeChanged to DashatarThemeBloc '
        'when tapped', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarThemePicker(),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      final int index = dashatarThemes.indexOf(NorthDashatarTheme());

      await tester.tap(find.byKey(Key('dashatar_theme_picker_$index')));

      verify(
        () => dashatarThemeBloc.add(DashatarThemeChanged(themeIndex: index)),
      ).called(1);
    });

    testWidgets(
        'plays DashatarTheme.audioAsset sound '
        'when tapped', (WidgetTester tester) async {
      final MockAudioPlayer audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.stop).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});

      await tester.pumpApp(
        DashatarThemePicker(
          audioPlayer: () => audioPlayer,
        ),
        dashatarThemeBloc: dashatarThemeBloc,
        audioControlBloc: audioControlBloc,
      );

      final NorthDashatarTheme theme = NorthDashatarTheme();
      final int index = dashatarThemes.indexOf(theme);

      await tester.tap(find.byKey(Key('dashatar_theme_picker_$index')));

      verify(() => audioPlayer.setAsset(theme.audioAsset)).called(1);
      verify(audioPlayer.play).called(1);
    });
  });
}
