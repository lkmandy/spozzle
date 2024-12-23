// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarTimer', () {
    late TimerBloc timerBloc;

    setUp(() {
      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());
    });

    testWidgets('renders on a large display', (WidgetTester tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_timer')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a medium display', (WidgetTester tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_timer')),
        findsOneWidget,
      );
    });

    testWidgets('renders on a small display', (WidgetTester tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_timer')),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders secondsElapsed from TimerBloc '
        'when secondsElapsed is less than a minute', (WidgetTester tester) async {
      when(() => timerBloc.state).thenReturn(
        TimerState(secondsElapsed: 20),
      );

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(find.text('00:00:20'), findsOneWidget);
    });

    testWidgets(
        'renders secondsElapsed from TimerBloc '
        'when secondsElapsed is more than a minute', (WidgetTester tester) async {
      const int secondsElapsed = 150;
      when(() => timerBloc.state)
          .thenReturn(TimerState(secondsElapsed: secondsElapsed));

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(find.text('00:02:30'), findsOneWidget);
    });

    testWidgets(
        'renders secondsElapsed from TimerBloc '
        'when secondsElapsed is more than an hour', (WidgetTester tester) async {
      const int secondsElapsed = 5450;
      when(() => timerBloc.state)
          .thenReturn(TimerState(secondsElapsed: secondsElapsed));

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(find.text('01:30:50'), findsOneWidget);
    });

    testWidgets(
        'renders semanticsLabel '
        'based on secondsElapsed from TimerBloc', (WidgetTester tester) async {
      const int secondsElapsed = 5450;
      when(() => timerBloc.state)
          .thenReturn(TimerState(secondsElapsed: secondsElapsed));

      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(
        find.bySemanticsLabel('1 hours 30 minutes 50 seconds'),
        findsOneWidget,
      );
    });

    testWidgets('renders timer icon', (WidgetTester tester) async {
      await tester.pumpApp(
        DashatarTimer(),
        timerBloc: timerBloc,
      );

      expect(
        find.byKey(Key('dashatar_timer_icon')),
        findsOneWidget,
      );
    });
  });
}
