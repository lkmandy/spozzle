import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../audio_control/audio_control.dart';
import '../../helpers/helpers.dart';
import '../../layout/layout.dart';
import '../../puzzle/puzzle.dart';
import '../../timer/timer.dart';
import '../dashatar.dart';

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template dashatar_puzzle_board}
/// Displays the board of the puzzle in a [Stack] filled with [tiles].
/// {@endtemplate}
class DashatarPuzzleBoard extends StatefulWidget {
  /// {@macro dashatar_puzzle_board}
  const DashatarPuzzleBoard({
    Key? key,
    required this.tiles,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;
  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarPuzzleBoard> createState() => _DashatarPuzzleBoardState();
}

class _DashatarPuzzleBoardState extends State<DashatarPuzzleBoard> {
  Timer? _completePuzzleTimer;
  AudioPlayer? _audioPlayer;

  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/tile_move.mp3');
    });
    super.initState();
  }

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashatarPuzzleStatus status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    final bool hasStarted = status == DashatarPuzzleStatus.started;
    final bool puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;
    final bool canSlide = hasStarted && puzzleIncomplete;
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (BuildContext context, PuzzleState state) async {
        if (state.puzzleStatus == PuzzleStatus.complete) {
          _completePuzzleTimer =
              Timer(const Duration(milliseconds: 370), () async {
            await showAppDialog<void>(
              context: context,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<DashatarThemeBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<PuzzleBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<TimerBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<AudioControlBloc>(),
                  ),
                ],
                child: const DashatarShareDialog(),
              ),
            );
          });
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, Widget? child) => SizedBox.square(
          key: const Key('dashatar_puzzle_board_small'),
          dimension: _BoardSize.small,
          child: child,
        ),
        medium: (_, Widget? child) => SizedBox.square(
          key: const Key('dashatar_puzzle_board_medium'),
          dimension: _BoardSize.medium,
          child: child,
        ),
        large: (_, Widget? child) => SizedBox.square(
          key: const Key('dashatar_puzzle_board_large'),
          dimension: _BoardSize.large,
          child: child,
        ),
        child: (_) => GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            if (canSlide) {
              if (details.velocity.pixelsPerSecond.dy < -250 &&
                  context.read<PuzzleBloc>().state.puzzle.canSwipeUp()) {
                // Swipe up
                unawaited(_audioPlayer?.replay());
                if (!context.read<TimerBloc>().state.isRunning) {
                  context.read<TimerBloc>().add(const TimerResumed());
                }
                context.read<PuzzleBloc>().add(const SwipeUp());
              } else if (details.velocity.pixelsPerSecond.dy > 250 &&
                  context.read<PuzzleBloc>().state.puzzle.canSwipeDown()) {
                // Swipe down
                unawaited(_audioPlayer?.replay());
                if (!context.read<TimerBloc>().state.isRunning) {
                  context.read<TimerBloc>().add(const TimerResumed());
                }
                context.read<PuzzleBloc>().add(const SwipeDown());
              }
            }
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (canSlide) {
              if (details.velocity.pixelsPerSecond.dx < 0 &&
                  context.read<PuzzleBloc>().state.puzzle.canSwipeleft()) {
                // swipe left
                unawaited(_audioPlayer?.replay());
                if (!context.read<TimerBloc>().state.isRunning) {
                  context.read<TimerBloc>().add(const TimerResumed());
                }
                context.read<PuzzleBloc>().add(const SwipeLeft());
              } else if (details.velocity.pixelsPerSecond.dx > 0 &&
                  context.read<PuzzleBloc>().state.puzzle.canSwipeRight()) {
                // swipe right
                unawaited(_audioPlayer?.replay());
                if (!context.read<TimerBloc>().state.isRunning) {
                  context.read<TimerBloc>().add(const TimerResumed());
                }
                context.read<PuzzleBloc>().add(const SwipeRight());
              }
            }
          },
          child: Stack(
            children: widget.tiles,
          ),
        ),
      ),
    );
  }
}
