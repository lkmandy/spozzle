// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/timer/timer.dart';

import '../../helpers/helpers.dart';

void main() {
  final MockTicker ticker = MockTicker();
  final StreamController<int> streamController = StreamController<int>.broadcast();

  setUp(() {
    when(ticker.tick).thenAnswer((_) => streamController.stream);
  });

  group('TimerBloc', () {
    test('initial state is TimerState', () {
      expect(
        TimerBloc(ticker: ticker).state,
        TimerState(),
      );
    });

    group('TimerStarted', () {
      test('emits 3 sequential timer states', () async {
        final TimerBloc bloc = TimerBloc(ticker: ticker)..add(TimerStarted());
        await bloc.stream.first;

        streamController
          ..add(1)
          ..add(2)
          ..add(3);

        await expectLater(
          bloc.stream,
          emitsInOrder(<TimerState>[
            TimerState(isRunning: true, secondsElapsed: 1),
            TimerState(isRunning: true, secondsElapsed: 2),
            TimerState(isRunning: true, secondsElapsed: 3),
          ]),
        );
      });
    });

    group('TimerTicked', () {
      blocTest<TimerBloc, TimerState>(
        'emits 1 when seconds elapsed is 1',
        build: () => TimerBloc(ticker: ticker),
        act: (TimerBloc bloc) => bloc.add(TimerTicked(1)),
        expect: () => <TimerState>[TimerState(secondsElapsed: 1)],
      );
    });

    group('TimerStopped', () {
      test('does not emit after timer is stopped', () async {
        final TimerBloc bloc = TimerBloc(ticker: ticker)..add(TimerStarted());

        expect(
          await bloc.stream.first,
          equals(TimerState(isRunning: true, secondsElapsed: 0)),
        );

        streamController.add(1);
        expect(
          await bloc.stream.first,
          equals(TimerState(isRunning: true, secondsElapsed: 1)),
        );

        bloc.add(TimerStopped());
        streamController.add(2);

        expect(
          await bloc.stream.first,
          equals(TimerState(isRunning: false, secondsElapsed: 1)),
        );
      });
    });

    group('TimerReset', () {
      blocTest<TimerBloc, TimerState>(
        'emits new timer state',
        build: () => TimerBloc(ticker: ticker),
        act: (TimerBloc bloc) => bloc.add(TimerReset()),
        expect: () => <TimerState>[TimerState()],
      );
    });
  });
}
