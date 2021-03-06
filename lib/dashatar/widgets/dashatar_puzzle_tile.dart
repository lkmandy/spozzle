import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../audio_control/audio_control.dart';
import '../../helpers/helpers.dart';
import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../models/models.dart';
import '../../puzzle/puzzle.dart';
import '../../theme/themes/themes.dart';
import '../../timer/bloc/timer_bloc.dart';
import '../dashatar.dart';

abstract class _TileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
}

/// {@template dashatar_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class DashatarPuzzleTile extends StatefulWidget {
  /// {@macro dashatar_puzzle_tile}
  const DashatarPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarPuzzleTile> createState() => DashatarPuzzleTileState();
}

/// The state of [DashatarPuzzleTile].
@visibleForTesting
class DashatarPuzzleTileState extends State<DashatarPuzzleTile>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    // Delay the initialization of the audio player for performance reasons,
    // to avoid dropping frames when the theme is changed.
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/tile_move.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int size = widget.state.puzzle.getDimension();
    final DashatarTheme theme =
        context.select((DashatarThemeBloc bloc) => bloc.state.theme);
    final DashatarPuzzleStatus status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    final bool hasStarted = status == DashatarPuzzleStatus.started;
    final bool puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final Duration movementDuration = status == DashatarPuzzleStatus.loading
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 350);

    final bool canPress = hasStarted && puzzleIncomplete;

    final bool canSwipeUp =
        context.read<PuzzleBloc>().state.puzzle.canSwipeUp(widget.tile);
    final bool canSwipeDown =
        context.read<PuzzleBloc>().state.puzzle.canSwipeDown(widget.tile);
    final bool canSwipeleft =
        context.read<PuzzleBloc>().state.puzzle.canSwipeleft(widget.tile);
    final bool canSwipeRight =
        context.read<PuzzleBloc>().state.puzzle.canSwipeRight(widget.tile);
    final bool canMove =
        context.read<PuzzleBloc>().state.puzzle.isTileMovable(widget.tile);

    void swipeTile() {
      if (canMove) unawaited(_audioPlayer?.replay());
      if (!context.read<TimerBloc>().state.isRunning) {
        context.read<TimerBloc>().add(const TimerResumed());
      }
      context.read<PuzzleBloc>().add(TileTapped(widget.tile));
    }

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (widget.tile.currentPosition.x - 1) / (size - 1),
          (widget.tile.currentPosition.y - 1) / (size - 1),
        ),
        duration: movementDuration,
        curve: Curves.easeInOut,
        child: ResponsiveLayoutBuilder(
          small: (_, Widget? child) => SizedBox.square(
            key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
            dimension: _TileSize.small,
            child: child,
          ),
          medium: (_, Widget? child) => SizedBox.square(
            key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
            dimension: _TileSize.medium,
            child: child,
          ),
          large: (_, Widget? child) => SizedBox.square(
            key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
            dimension: _TileSize.large,
            child: child,
          ),
          child: (ResponsiveLayoutSize size) => GestureDetector(
            onPanDown: canPress
                ? (_) {
                    _controller.forward();
                  }
                : null,
            onPanCancel: canPress
                ? () {
                    _controller.reverse();
                  }
                : null,
            onVerticalDragStart: canPress
                ? (_) {
                    _controller.forward();
                  }
                : null,
            onHorizontalDragStart: canPress
                ? (_) {
                    _controller.forward();
                  }
                : null,
            onVerticalDragEnd: (canPress && (canSwipeUp || canSwipeDown))
                ? (DragEndDetails details) {
                    if ((details.velocity.pixelsPerSecond.dy < 1 &&
                            canSwipeUp) ||
                        (details.velocity.pixelsPerSecond.dy > 1 &&
                            canSwipeDown)) {
                      // Swipe down
                      swipeTile();
                      _controller.reverse();
                    }
                  }
                : null,
            onHorizontalDragEnd: (canPress && (canSwipeleft || canSwipeRight))
                ? (DragEndDetails details) {
                    if ((details.velocity.pixelsPerSecond.dx < 1 &&
                            canSwipeleft) ||
                        (details.velocity.pixelsPerSecond.dx > 1 &&
                            canSwipeRight)) {
                      // swipe right
                      swipeTile();
                      _controller.reverse();
                    }
                  }
                : null,
            child: MouseRegion(
              onEnter: (_) {
                if (canPress) {
                  _controller.forward();
                }
              },
              onExit: (_) {
                if (canPress) {
                  _controller.reverse();
                }
              },
              child: ScaleTransition(
                key: Key('dashatar_puzzle_tile_scale_${widget.tile.value}'),
                scale: _scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: (canPress && size == ResponsiveLayoutSize.large)
                        ? swipeTile
                        : null,
                    // canPress ? () {} : null,
                    icon: Image.asset(
                      theme.dashAssetForTile(widget.tile),
                      semanticLabel: context.l10n.puzzleTileLabelText(
                        widget.tile.value.toString(),
                        widget.tile.currentPosition.x.toString(),
                        widget.tile.currentPosition.y.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
