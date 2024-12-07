// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spozzle/dashatar/dashatar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DashatarTheme', () {
    group('BlueDashatarTheme', () {
      test('supports value comparisons', () {
        expect(
          WestDashatarTheme(),
          equals(WestDashatarTheme()),
        );
      });

      test('uses DashatarPuzzleLayoutDelegate', () {
        expect(
          WestDashatarTheme().layoutDelegate,
          equals(DashatarPuzzleLayoutDelegate()),
        );
      });

      test('dashAssetForTile returns correct assets', () {
        final MockTile tile = MockTile();
        const int tileValue = 6;
        when(() => tile.value).thenReturn(tileValue);
        expect(
          WestDashatarTheme().dashAssetForTile(tile),
          equals('assets/images/dashatar/blue/6.png'),
        );
      });
    });

    group('GreenDashatarTheme', () {
      test('supports value comparisons', () {
        expect(
          LittoralDashatarTheme(),
          equals(LittoralDashatarTheme()),
        );
      });

      test('uses DashatarPuzzleLayoutDelegate', () {
        expect(
          LittoralDashatarTheme().layoutDelegate,
          equals(DashatarPuzzleLayoutDelegate()),
        );
      });

      test('dashAssetForTile returns correct assets', () {
        final MockTile tile = MockTile();
        const int tileValue = 6;
        when(() => tile.value).thenReturn(tileValue);
        expect(
          LittoralDashatarTheme().dashAssetForTile(tile),
          equals('assets/images/dashatar/green/6.png'),
        );
      });
    });

    group('YellowDashatarTheme', () {
      test('supports value comparisons', () {
        expect(
          NorthDashatarTheme(),
          equals(NorthDashatarTheme()),
        );
      });

      test('uses DashatarPuzzleLayoutDelegate', () {
        expect(
          NorthDashatarTheme().layoutDelegate,
          equals(DashatarPuzzleLayoutDelegate()),
        );
      });

      test('dashAssetForTile returns correct assets', () {
        final MockTile tile = MockTile();
        const int tileValue = 6;
        when(() => tile.value).thenReturn(tileValue);
        expect(
          NorthDashatarTheme().dashAssetForTile(tile),
          equals('assets/images/dashatar/yellow/6.png'),
        );
      });
    });
  });
}
