// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarShareYourScore', () {
    late DashatarShareDialogEnterAnimation animation;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      animation = DashatarShareDialogEnterAnimation(
        AnimationController(vsync: TestVSync()),
      );

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_share_your_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_share_your_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_share_your_score')),
        findsOneWidget,
      );
    });

    testWidgets('renders title', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_share_your_score_title')),
        findsOneWidget,
      );
    });

    testWidgets('renders message', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byKey(Key('dashatar_share_your_score_message')),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarTwitterButton', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byType(DashatarTwitterButton),
        findsOneWidget,
      );
    });

    testWidgets('renders DashatarFacebookButton', (WidgetTester tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: DashatarShareYourScore(animation: animation),
        ),
        audioControlBloc: audioControlBloc,
      );

      expect(
        find.byType(DashatarFacebookButton),
        findsOneWidget,
      );
    });
  });
}
