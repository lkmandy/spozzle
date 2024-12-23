// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/models/models.dart';

void main() {
  const int value = 1;
  const Position position = Position(x: 1, y: 1);
  const Position newPosition = Position(x: 2, y: 2);

  group('Tile', () {
    test('supports value comparisons', () {
      expect(
        const Tile(
          value: value,
          correctPosition: position,
          currentPosition: position,
        ),
        const Tile(
          value: value,
          correctPosition: position,
          currentPosition: position,
        ),
      );
    });

    group('copyWith', () {
      test(
          'returns object with updated current position when current position '
          'is passed', () {
        expect(
          Tile(
            value: value,
            correctPosition: position,
            currentPosition: position,
          ).copyWith(currentPosition: newPosition),
          equals(
            Tile(
              value: value,
              correctPosition: position,
              currentPosition: newPosition,
            ),
          ),
        );
      });
    });
  });
}
