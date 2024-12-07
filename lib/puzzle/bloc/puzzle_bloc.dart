// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<SwipeDown>(_swipeDown);
    on<SwipeUp>(_swipeUp);
    on<SwipeLeft>(_swipeLeft);
    on<SwipeRight>(_swipeRight);
    on<PuzzleReset>(_onPuzzleReset);
  }

  final int _size;

  final Random? random;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final Puzzle puzzle = _generatePuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    _moveTile(event.tile, emit);
  }

  void _swipeUp(SwipeUp event, Emitter<PuzzleState> emit) {
    final Tile? tile =
        state.puzzle.getTileRelativeToWhitespaceTile(const Offset(0, 1));
    _moveTile(tile!, emit);
  }

  void _swipeDown(SwipeDown event, Emitter<PuzzleState> emit) {
    final Tile? tile =
        state.puzzle.getTileRelativeToWhitespaceTile(const Offset(0, -1));
    _moveTile(tile!, emit);
  }

  void _swipeLeft(SwipeLeft event, Emitter<PuzzleState> emit) {
    final Tile? tile =
        state.puzzle.getTileRelativeToWhitespaceTile(const Offset(1, 0));
    _moveTile(tile!, emit);
  }

  void _swipeRight(SwipeRight event, Emitter<PuzzleState> emit) {
    final Tile? tile =
        state.puzzle.getTileRelativeToWhitespaceTile(const Offset(-1, 0));
    _moveTile(tile!, emit);
  }

  void _moveTile(Tile tile, Emitter<PuzzleState> emit) {
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tile)) {
        final Puzzle mutablePuzzle = Puzzle(tiles: <Tile>[...state.puzzle.tiles]);
        final Puzzle puzzle = mutablePuzzle.moveTiles(tile, <Tile>[]);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final Puzzle puzzle = _generatePuzzle(_size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final List<Position> correctPositions = <Position>[];
    final List<Position> currentPositions = <Position>[];
    final Position whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (int y = 1; y <= size; y++) {
      for (int x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final Position position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      currentPositions.shuffle(random);
    }

    List<Tile> tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    Puzzle puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final Position whitespacePosition = Position(x: size, y: size);
    return <Tile>[
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }
}
