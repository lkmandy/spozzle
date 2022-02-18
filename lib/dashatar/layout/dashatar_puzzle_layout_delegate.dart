import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/layout.dart';
import '../../models/models.dart';
import '../../puzzle/puzzle.dart';
import '../../theme/widgets/number_of_moves_and_tiles_left.dart';
import '../dashatar.dart';

// ignore: avoid_classes_with_only_static_members
/// {@template dashatar_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [DashatarTheme].
/// {@endtemplate}
class BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

class DashatarPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro dashatar_puzzle_layout_delegate}
  const DashatarPuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => DashatarStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const ResponsiveGap(
          small: 23,
          medium: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, Widget? child) => SizedBox(
              width: BoardSize.small,
              child: ControlAndPuzzleStatus(state: state)),
          medium: (_, Widget? child) => SizedBox(
              width: BoardSize.medium,
              child: ControlAndPuzzleStatus(state: state)),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        ResponsiveLayoutBuilder(
          small: (_, Widget? child) => const DashatarThemePicker(),
          medium: (_, Widget? child) => const DashatarThemePicker(),
          large: (_, Widget? child) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        const ResponsiveGap(
          large: 130,
        ),
        const DashatarCountdown(),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      bottom: 74,
      right: 50,
      child: ResponsiveLayoutBuilder(
        small: (_, Widget? child) => const SizedBox(),
        medium: (_, Widget? child) => const SizedBox(),
        large: (_, Widget? child) => const DashatarThemePicker(),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles, {PuzzleState? state}) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, Widget? child) => const SizedBox(),
            medium: (_, Widget? child) => const SizedBox(),
            large: (_, Widget? child) => const DashatarTimer(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 21,
              medium: 34,
              large: 96,
            ),
            DashatarPuzzleBoard(tiles: tiles),
            const ResponsiveGap(
              large: 34,
            ),
            ResponsiveLayoutBuilder(
              small: (_, Widget? child) => const SizedBox(),
              medium: (_, Widget? child) => const SizedBox(),
              large: (_, Widget? child) => SizedBox(
                  width: BoardSize.large,
                  child: ControlAndPuzzleStatus(state: state!)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return DashatarPuzzleTile(
      tile: tile,
      state: state,
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

class ControlAndPuzzleStatus extends StatelessWidget {
  const ControlAndPuzzleStatus({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final DashatarPuzzleStatus status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DashatarPuzzleActionButton(),
        // const ResponsiveGap(
        //   small: 12,
        //   medium: 16,
        //   large: 32,
        // ),
        NumberOfMovesAndTilesLeft(
          key: numberOfMovesAndTilesLeftKey,
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: status == DashatarPuzzleStatus.started
              ? state.numberOfTilesLeft
              : state.puzzle.tiles.length - 1,
        ),
      ],
    );
  }
}
