// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/simple/simple.dart';
import 'package:spozzle/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AudioControl', () {
    late ThemeBloc themeBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      themeBloc = MockThemeBloc();
      final ThemeState themeState = ThemeState(
        themes: <PuzzleTheme>[SimpleTheme(), LittoralDashatarTheme()],
        theme: SimpleTheme(),
      );
      when(() => themeBloc.state).thenReturn(themeState);

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state)
          .thenReturn(AudioControlState(muted: false));
    });

    testWidgets(
        'adds AudioToggled to AudioControlBloc '
        'when tapped and '
        'the audio is unmuted', (WidgetTester tester) async {
      when(() => audioControlBloc.state)
          .thenReturn(AudioControlState(muted: false));

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(AudioControl));

      verify(() => audioControlBloc.add(AudioToggled())).called(1);
    });

    testWidgets(
        'adds AudioToggled to AudioControlBloc '
        'when tapped and '
        'the audio is muted', (WidgetTester tester) async {
      when(() => audioControlBloc.state)
          .thenReturn(AudioControlState(muted: true));

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      await tester.tap(find.byType(AudioControl));

      verify(() => audioControlBloc.add(AudioToggled())).called(1);
    });

    testWidgets(
        'renders Image '
        'with PuzzleTheme.audioControlOnAsset '
        'when the audio is unmuted', (WidgetTester tester) async {
      final ThemeState themeState = ThemeState(
        themes: <PuzzleTheme>[SimpleTheme(), LittoralDashatarTheme()],
        theme: SimpleTheme(),
      );
      when(() => themeBloc.state).thenReturn(themeState);

      when(() => audioControlBloc.state)
          .thenReturn(AudioControlState(muted: false));

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              (widget.image as AssetImage).assetName ==
                  SimpleTheme().audioControlOnAsset,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Image '
        'with PuzzleTheme.audioControlOffAsset '
        'when the audio is muted', (WidgetTester tester) async {
      final ThemeState themeState = ThemeState(
        themes: <PuzzleTheme>[SimpleTheme(), LittoralDashatarTheme()],
        theme: LittoralDashatarTheme(),
      );
      when(() => themeBloc.state).thenReturn(themeState);

      when(() => audioControlBloc.state)
          .thenReturn(AudioControlState(muted: true));

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              (widget.image as AssetImage).assetName ==
                  LittoralDashatarTheme().audioControlOffAsset,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('audio_control_large')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('audio_control_medium')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        AudioControl(),
        themeBloc: themeBloc,
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('audio_control_small')),
        findsOneWidget,
      );
    });
  });
}
