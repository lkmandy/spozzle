// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => <Object>[];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => <Object>[shufflePuzzle];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => <Object>[tile];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}

class SwipeUp extends PuzzleEvent {
  const SwipeUp();
}

class SwipeDown extends PuzzleEvent {
  const SwipeDown();
}

class SwipeLeft extends PuzzleEvent {
  const SwipeLeft();
}

class SwipeRight extends PuzzleEvent {
  const SwipeRight();
}
