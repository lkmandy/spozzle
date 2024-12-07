import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/models/models.dart';

void main() {
  group('Ticker', () {
    group('tick', () {
      test('returns stream of integers', () {
        const Ticker ticker = Ticker();
        final Stream<int> stream = ticker.tick();
        expect(stream, isA<Stream<int>>());
      });

      test('returns stream of integers counting up from 1', () async {
        await fakeAsync((FakeAsync async) async {
          final List<int> events = <int>[];
          const Ticker ticker = Ticker();
          final StreamSubscription<int> subscription = ticker.tick().listen(events.add);
          async.elapse(const Duration(seconds: 20));
          await subscription.cancel();
          expect(
            events,
            <int>[
              for (int i = 1; i <= 20; i++) i,
            ],
          );
        });
      });
    });
  });
}
