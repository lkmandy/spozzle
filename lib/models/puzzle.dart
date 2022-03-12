import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'models.dart';

// A 3x3 puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template puzzle}
/// Model for a puzzle.
/// {@endtemplate}
class Puzzle extends Equatable {
  /// {@macro puzzle}
  const Puzzle({required this.tiles});

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<Tile> tiles;

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  /// Gets the single whitespace tile object in the puzzle.
  Tile getWhitespaceTile() {
    return tiles.singleWhere((Tile tile) => tile.isWhitespace);
  }

  /// Gets the tile relative to the whitespace tile in the puzzle
  /// defined by [relativeOffset].
  Tile? getTileRelativeToWhitespaceTile(Offset relativeOffset) {
    final Tile whitespaceTile = getWhitespaceTile();
    return tiles.singleWhereOrNull(
      (Tile tile) =>
          tile.currentPosition.x ==
              whitespaceTile.currentPosition.x + relativeOffset.dx &&
          tile.currentPosition.y ==
              whitespaceTile.currentPosition.y + relativeOffset.dy,
    );
  }

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles() {
    final Tile whitespaceTile = getWhitespaceTile();
    int numberOfCorrectTiles = 0;
    for (final Tile tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.currentPosition == tile.correctPosition) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }

  /// Determines if the puzzle is completed.
  bool isComplete() {
    return (tiles.length - 1) - getNumberOfCorrectTiles() == 0;
    // return true;
  }

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final Tile whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }
    return true;
  }

  bool canSwipeUp() {
    final Tile? downTile = getTileRelativeToWhitespaceTile(const Offset(0, 1));
    if (downTile != null) print('${downTile.value} downTile');
    if (downTile != null && isTileMovable(downTile)) {
      return true;
    } else {
      return false;
    }
  }

  bool canSwipeDown() {
    final Tile? upTile = getTileRelativeToWhitespaceTile(const Offset(0, -1));
    if (upTile != null) print('${upTile.value} upTile');
    print('upTile');
    if (upTile != null && isTileMovable(upTile)) {
      return true;
    } else {
      return false;
    }
  }

  bool canSwipeleft() {
    final Tile? rightTile = getTileRelativeToWhitespaceTile(const Offset(1, 0));
    if (rightTile != null) print('${rightTile.value} rightTile');
    if (rightTile != null && isTileMovable(rightTile)) {
      return true;
    } else {
      return false;
    }
  }

  bool canSwipeRight() {
    final Tile? leftTile = getTileRelativeToWhitespaceTile(const Offset(-1, 0));
    if (leftTile != null) print('${leftTile.value} leftTile');
    if (leftTile != null && isTileMovable(leftTile)) {
      return true;
    } else {
      return false;
    }
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final int size = getDimension();
    final int height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final int inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final Tile whitespace = tiles.singleWhere((Tile tile) => tile.isWhitespace);
    final int whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    int count = 0;
    for (int a = 0; a < tiles.length; a++) {
      final Tile tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (int b = a + 1; b < tiles.length; b++) {
        final Tile tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    final Tile whitespaceTile = getWhitespaceTile();
    final int deltaX =
        whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final int deltaY =
        whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final int shiftPointX = tile.currentPosition.x + deltaX.sign;
      final int shiftPointY = tile.currentPosition.y + deltaY.sign;
      final Tile tileToSwapWith = tiles.singleWhere(
        (Tile tile) =>
            tile.currentPosition.x == shiftPointX &&
            tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(List<Tile> tilesToSwap) {
    for (final Tile tileToSwap in tilesToSwap.reversed) {
      final int tileIndex = tiles.indexOf(tileToSwap);
      final Tile tile = tiles[tileIndex];
      final Tile whitespaceTile = getWhitespaceTile();
      final int whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }

    return Puzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  Puzzle sort() {
    final List<Tile> sortedTiles = tiles.toList()
      ..sort((Tile tileA, Tile tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    return Puzzle(tiles: sortedTiles);
  }

  @override
  List<Object> get props => [tiles];
}
